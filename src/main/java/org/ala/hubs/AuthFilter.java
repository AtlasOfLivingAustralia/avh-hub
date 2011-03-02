package org.ala.hubs;


import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import au.org.ala.cas.client.UriFilter;
import org.apache.log4j.Logger;
import org.jasig.cas.client.authentication.AuthenticationFilter;

import au.org.ala.cas.util.AuthenticationCookieUtils;
import au.org.ala.cas.util.PatternMatchingUtils;

/**
 * Meta filter that provides filtering based on URI patterns that require authentication (and thus redirection) to the CAS server.
 * <p>
 * The list of URI patterns is specified as a comma delimited list of regular expressions in a &lt;context-param&gt;, <code>uriFilterPattern</code>.
 * <p>
 * So if a request's path matches one of the URI patterns then the filter specified by the <code>filterClass</code> &lt;init-param&gt; is invoked.
 * <p>
 * The <code>contextPath</code> parameter value (if present) is prefixed to each URI pattern defined in the <code>uriFilterPattern</code> list.
 * <p>
 * An example of usage is shown in the following web.xml fragment,
 * <p><pre>
     ...
     &lt;context-param&gt;
         &lt;param-name&gt;contextPath&lt;/param-name&gt;
         &lt;param-value&gt;/biocache-webapp&lt;/param-value&gt;
     &lt;/context-param&gt;

     &lt;context-param&gt;
         &lt;param-name&gt;uriFilterPattern&lt;/param-name&gt;
         &lt;param-value&gt;/occurrences/\d+&lt;/param-value&gt;
     &lt;/context-param&gt;

     &lt;!-- CAS Authentication Service filters --&gt;
     &lt;filter&gt;
         &lt;filter-name&gt;CAS Authentication Filter&lt;/filter-name&gt;
         &lt;filter-class&gt;au.org.ala.cas.client.UriFilter&lt;/filter-class&gt;
         &lt;init-param&gt;
             &lt;param-name&gt;filterClass&lt;/param-name&gt;
             &lt;param-value&gt;org.jasig.cas.client.authentication.AuthenticationFilter&lt;/param-value&gt;
         &lt;/init-param&gt;
         &lt;init-param&gt;
             &lt;param-name&gt;casServerLoginUrl&lt;/param-name&gt;
             &lt;param-value&gt;https://auth.ala.org.au/cas/login&lt;/param-value&gt;
         &lt;/init-param&gt;
         &lt;init-param&gt;
             &lt;param-name&gt;gateway&lt;/param-name&gt;
             &lt;param-value&gt;true&lt;/param-value&gt;
         &lt;/init-param&gt;
     &lt;/filter&gt;
     ...
 * </pre>
 * @author peter flemming
 */
public class AuthFilter implements Filter {

    private final static Logger logger = Logger.getLogger(AuthFilter.class);

    private static final String URI_FILTER_PATTERN = "uriFilterPattern";
    private static final String AUTHENTICATE_ONLY_IF_LOGGED_IN_FILTER_PATTERN = "authenticateOnlyIfLoggedInFilterPattern";
    private static final String URI_FILTER_EXCLUSION_PATTERN = "uriExclusionFilterPattern";

    private Filter filter;
    private String contextPath;
    private List<Pattern> uriInclusionPatterns;
    private List<Pattern> uriExclusionPatterns;
    private List<Pattern> authOnlyIfLoggedInPatterns;

    public void init(FilterConfig filterConfig) throws ServletException {

        //
        // Get contextPath param
        //
        this.contextPath = filterConfig.getServletContext().getInitParameter("contextPath");
        if (this.contextPath == null) {
            this.contextPath = "";
        } else {
            logger.debug("Context path = '" + contextPath + "'");
        }

        //
        // Get URI inclusion filter patterns
        //
        String includedUrlPattern = filterConfig.getServletContext().getInitParameter(URI_FILTER_PATTERN);
        if (includedUrlPattern == null) {
            includedUrlPattern = "";
        }
        logger.debug("Included URI Pattern = '" + includedUrlPattern + "'");
        this.uriInclusionPatterns = PatternMatchingUtils.getPatternList(contextPath, includedUrlPattern);

        //
        // Get URI exclusion filter patterns
        //
        String uriExclusionPattern = filterConfig.getServletContext().getInitParameter(URI_FILTER_EXCLUSION_PATTERN);
        if (uriExclusionPattern == null) {
            uriExclusionPattern = "";
        }
        logger.debug("URL exclusion Pattern = '" + uriExclusionPattern + "'");
        this.uriExclusionPatterns = PatternMatchingUtils.getPatternList(contextPath, uriExclusionPattern);

        //
        // Get Authenticate Only if Logged in filter patterns
        //
        String authOnlyIfLoggedInPattern = filterConfig.getServletContext().getInitParameter(AUTHENTICATE_ONLY_IF_LOGGED_IN_FILTER_PATTERN);
        if (authOnlyIfLoggedInPattern == null) {
            authOnlyIfLoggedInPattern = "";
        }
        logger.debug("Authenticate Only if Logged in Pattern = '" + authOnlyIfLoggedInPattern + "'");
        this.authOnlyIfLoggedInPatterns = PatternMatchingUtils.getPatternList(contextPath, authOnlyIfLoggedInPattern);

        //
        // Get target filter class name
        //
        String className = filterConfig.getInitParameter("filterClass");
        try {
            Class<?> c = Class.forName(className);
            filter = (Filter) c.newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        filter.init(filterConfig);
    }

    /* (non-Javadoc)
     * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
     */
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        String requestUri = ((HttpServletRequest) request).getRequestURI();
        if (filter instanceof AuthenticationFilter) {
            logger.debug("Filter Request Uri = '" + requestUri + "'");
        }

        if (PatternMatchingUtils.matches(requestUri, uriInclusionPatterns) && !PatternMatchingUtils.matches(requestUri,uriExclusionPatterns)) {

            logger.debug("URI '" + requestUri + "' is a recognised inclusion pattern " + URI_FILTER_PATTERN);

            if (filter instanceof AuthenticationFilter) {
                logger.debug("Forwarding URI '" + requestUri + "' to CAS authentication filters because it matches " + URI_FILTER_PATTERN);
            }
            filter.doFilter(request, response, chain);
        } else if (PatternMatchingUtils.matches(requestUri, authOnlyIfLoggedInPatterns) && !PatternMatchingUtils.matches(requestUri,uriExclusionPatterns)) {

            logger.debug("URI '" + requestUri + "' is a recognised authOnlyIfLoggedInPatterns pattern " + URI_FILTER_PATTERN);

            if (filter instanceof AuthenticationFilter) {
                logger.debug("Forwarding URI '" + requestUri + "' to CAS authentication filters because it matches " + AUTHENTICATE_ONLY_IF_LOGGED_IN_FILTER_PATTERN + " and ALA-Auth cookie exists");
            }
            filter.doFilter(request, response, chain);
        } else {

            logger.debug("URI '" + requestUri + "' is not a recognised pattern. No action required.");
            chain.doFilter(request, response);
        }
    }

    public void destroy() {
        filter.destroy();
    }
}

