/* *************************************************************************
 *  Copyright (C) 2013 Atlas of Living Australia
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

import org.ala.hubs.dto.OutageBanner;
import org.ala.hubs.service.OutageService;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.tags.RequestContextAwareTag;

import javax.inject.Inject;
import javax.servlet.jsp.JspException;
import java.util.Date;

/**
 * JSP TagLib to output an outage message if one is set and the dates allow it.
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public class OutageBannerTag extends RequestContextAwareTag {
    private final static Logger logger = Logger.getLogger(OutageBannerTag.class);
    @Inject
    OutageService outageService;

    @Override
    protected int doStartTagInternal() throws Exception {
        /*
         * Servlet Tags are instantiated by the Servlet and NOT by Spring but the
         * RequestContextAwareTag provides access to the request context, which then allows
         * us to autowire this class manually. In this case the OutageService implementation
         * is provided which uses EhCache to provide caching of the bean (5 minutes before it
         * then goes to disk to see if there has been a change).
         */
        if (outageService == null) {
            logger.debug("Autowiring the bean");
            WebApplicationContext wac = getRequestContext().getWebApplicationContext();
            AutowireCapableBeanFactory acbf = wac.getAutowireCapableBeanFactory();
            acbf.autowireBean(this);
        }

        OutageBanner ob = outageService.getOutageBanner();
        String message = ob.getMessage();
        Date now = new Date();

        if (ob.getShowMessage() != null && ob.getShowMessage()) {
            // showMessage is checked
            // Do a date comparison to see if today is between the startDate and endDate (inclusive)
            if (DateUtils.isSameDay(now, ob.getStartDate()) || now.after(ob.getStartDate())) {
                if (DateUtils.isSameDay(now, ob.getEndDate()) || now.before(ob.getEndDate())) {
                    // output the banner message
                    pageContext.getOut().print("<div id='outageMessage'>" + message + "</div>");
                } else {
                    logger.debug("now is not on or before endDate");
                }
            } else {
                logger.debug("now is not on or after startDate");
            }
        }

        return SKIP_BODY;
    }
}