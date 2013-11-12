package org.ala.hubs.skins;


import javax.annotation.PostConstruct;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import java.io.IOException;
import java.util.*;
import org.springframework.beans.factory.annotation.Value;

public class SkinFilter implements Filter {

    protected String barePatternsString;
    protected List<String> barePatterns = new ArrayList<String>();
    @Value("${sitemesh.skin}")
    protected String skin = "ala";
    protected String bareSkinSuffix = "-bare";
    private final static Logger log = Logger.getLogger(SkinFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        WebApplicationContext springContext = 
                WebApplicationContextUtils.getWebApplicationContext(filterConfig.getServletContext());
        
        
        String barePatternsAsString = filterConfig.getInitParameter("barePatterns");
        barePatterns = Arrays.asList(barePatternsAsString.split(","));
    }

    /**
     * init method above does not appear to be called when filter is specified as DelegatingFilterProxy in web.xml
     */
    @PostConstruct
    public void initSpring() {
        barePatterns = Arrays.asList(barePatternsString.split(","));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        //log.debug("barePatterns = " + StringUtils.join(barePatterns, "|"));
        boolean isBare = false;
        if(request instanceof HttpServletRequest){
            String uri = ((HttpServletRequest) request).getRequestURI();
            for(String p: barePatterns){
                if(uri.contains(p)){
                    isBare = true;
                    break;
                }
            }
            if(isBare){
                 request.setAttribute("skin",this.skin + bareSkinSuffix);
            } else {
                request.setAttribute("skin",this.skin);
            }
        } else {
            request.setAttribute("skin",this.skin);
        }

        chain.doFilter(request,response);
    }

    @Override
    public void destroy() {
        //To change body of implemented methods use File | Settings | File Templates.
    }

    /**
     * @return the barePatterns
     */
    public List<String> getBarePatterns() {
        return barePatterns;
    }

    /**
     * @param barePatterns the barePatterns to set
     */
    public void setBarePatterns(List<String> barePatterns) {
        this.barePatterns = barePatterns;
    }

    public String getBarePatternsString() {
        return barePatternsString;
    }

    public void setBarePatternsString(String barePatternsString) {
        this.barePatternsString = barePatternsString;
    }
}
