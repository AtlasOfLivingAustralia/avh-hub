/**************************************************************************
 *  Copyright (C) 2012 Atlas of Living Australia
 *  All Rights Reserved.
 *
 *  The contents of this file are subject to the Mozilla Public
 *  License Version 1.1 (the "License"); you may not use this file
 *  except in compliance with the License. You may obtain a copy of
 *  the License at http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS
 *  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 *  implied. See the License for the specific language governing
 *  rights and limitations under the License.
 ***************************************************************************/
package org.ala.hubs.util;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

import au.org.ala.cas.util.AuthenticationCookieUtils;
import org.apache.log4j.Logger;

/**
 * Simple tag that writes out a login/logout anchor element based on confirmed authentication status (not relying on ALA-Auth cookie).
 *
 * @author Peter Flemming
 */
public class LoginLogoutTag extends TagSupport {

    private static final long serialVersionUID = -6406031197753714478L;
    protected static Logger logger = Logger.getLogger(LoginLogoutTag.class);

    private String returnUrlPath = "";
    private String logoutControllerPath = "";

    /**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    public int doStartTag() throws JspException {

        HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
        String casServer = pageContext.getServletContext().getInitParameter("casServerName");
        String logoutUrl;

        if (!logoutControllerPath.isEmpty()) {
            logoutUrl = logoutControllerPath + "?casUrl=" + casServer + "/cas/logout&appUrl=" + returnUrlPath;
        } else {
            logoutUrl = casServer + "/cas/logout?url=" + returnUrlPath;
        }
        // Check authentication status
        Principal principal = request.getUserPrincipal();
        String html;
        if (principal != null) {
            html = "<a href='" + logoutUrl + "'>Log out</a>\n";
        } else {
            String userId = AuthenticationCookieUtils.getUserName(request);

            if (userId != null) {
                html = "<a href='" + logoutUrl + "'>Log out</a>\n";
            } else {
                html = "<a href='" + casServer + "/cas/login?service=" + returnUrlPath + "'>Log in</a>\n";
            }
        }

        try {
            pageContext.getOut().print(html);
        } catch (Exception e) {
            logger.error("LoginLogoutTag: " + e.getMessage(), e);
            throw new JspTagException("LoginLogoutTag: " + e.getMessage());
        }

        return super.doStartTag();
    }

    public String getReturnUrlPath() {
        return returnUrlPath;
    }

    public void setReturnUrlPath(String returnUrlPath) {
        this.returnUrlPath = returnUrlPath;
    }

    public String getLogoutControllerPath() {
        return logoutControllerPath;
    }

    public void setLogoutControllerPath(String logoutControllerPath) {
        this.logoutControllerPath = logoutControllerPath;
    }
}