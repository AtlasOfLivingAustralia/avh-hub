package org.ala.hubs.skins;


import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

public class SkinFilter implements Filter {

    protected List<String> barePatterns = new ArrayList<String>();
    protected String skin = null;
    protected String bareSkinSuffix = "-bare";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String barePatternsAsString = filterConfig.getInitParameter("barePatterns");
        this.skin = filterConfig.getInitParameter("skin");
        if(this.skin == null){
            this.skin = "ala";
        }
        barePatterns = Arrays.asList(barePatternsAsString.split(","));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

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
}
