/* *************************************************************************
 *  Copyright (C) 2014 Atlas of Living Australia
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

import org.ala.hubs.service.WebService;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.tags.RequestContextAwareTag;

import javax.inject.Inject;
import javax.servlet.ServletContext;
import java.io.*;


/**
 * Taglib for inserting header from external URL or internal JSP
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public class GenericSkinTag extends RequestContextAwareTag {
    private final static Logger logger = Logger.getLogger(GenericSkinTag.class);
    @Inject
    private ServletContext servletContext;
    @Inject
    private WebService apacheHttpWebService;
    @Value("${site.headerUrl:/WEB-INF/genericSkin/header.jsp}")
    private String headerUrl = null;
    @Value("${site.displayName:Generic Skin}")
    private String displayName = null;

    @Override
    protected int doStartTagInternal() throws Exception {
        /*
         * Servlet Tags are instantiated by the Servlet and NOT by Spring but the
         * RequestContextAwareTag provides access to the request context, which then allows
         * us to autowire this class manually.
         */
        if (apacheHttpWebService == null) {
            logger.debug("Autowiring the bean");
            WebApplicationContext wac = getRequestContext().getWebApplicationContext();
            AutowireCapableBeanFactory acbf = wac.getAutowireCapableBeanFactory();
            acbf.autowireBean(this);
        }

        String headerHtml = "";

        if (StringUtils.startsWith(headerUrl, "http")) {
            // external HTTP url
            headerHtml = apacheHttpWebService.getForUrl(headerUrl); // cached by EhCache
        } else if (StringUtils.isNotBlank(headerUrl)) {
            // internal file
            InputStream inputStream = null;
            try {
                inputStream = servletContext.getResourceAsStream(headerUrl);
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                headerHtml = org.apache.commons.io.IOUtils.toString(bufferedReader); //bufferedReader.readLine();
            } catch (Exception ex) {
                logger.error("Error reading header: " + ex.getLocalizedMessage(), ex);
            } finally {
                if (inputStream != null) {
                    inputStream.close();
                }
            }
        }

        if (StringUtils.isNotBlank(headerHtml)) {
            // JSTL style substitution
            headerHtml = StringUtils.replace(headerHtml, "${orgNameLong}", displayName);
            headerHtml = StringUtils.replace(headerHtml, "class=\"container\"", "class=\"container-OFF\""); // CSS fix for full width
            pageContext.getOut().print(headerHtml);
        }

        return SKIP_BODY;
    }

}


