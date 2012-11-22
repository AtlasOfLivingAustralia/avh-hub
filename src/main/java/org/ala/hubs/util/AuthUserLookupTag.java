/* *************************************************************************
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

import org.ala.hubs.service.AuthService;
import org.apache.log4j.Logger;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.tags.RequestContextAwareTag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import java.util.Map;

/**
 * Taglib filter to lookup user name for id (email address) in auth.ala.org.au
 *
 * User: dos009
 * Date: 21/11/12
 * Time: 11:32 AM
 */
public class AuthUserLookupTag extends RequestContextAwareTag {
    protected static Logger logger = Logger.getLogger(AuthUserLookupTag.class);

    protected String userId;

    @Override
    public int doStartTagInternal() throws JspException {
        WebApplicationContext wc = getRequestContext().getWebApplicationContext();
        AuthService authService = (AuthService) wc.getBean("authService");
        Map<String, String> userNamesForIds = authService.getMapOfAllUserNamesById();

        String outputValue = userId.replaceAll("\\@\\w+", "..."); // obfuscate email address

        if (userNamesForIds.containsKey(userId)) {
            // do lookup
            outputValue = userNamesForIds.get(userId);
        }

        try {
            pageContext.getOut().print(outputValue);
        } catch (Exception e) {
            logger.error("AuthUserLookupTag: " + e.getMessage(), e);
            throw new JspTagException("AuthUserLookupTag: " + e.getMessage());
        }

        return super.doStartTag();
    }

    /**
     * @param userId the userId to set
     */
    public void setUserId(String userId) {
        this.userId = userId;
    }
}
