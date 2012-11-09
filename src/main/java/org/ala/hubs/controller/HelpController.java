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

package org.ala.hubs.controller;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.multiaction.NoSuchRequestHandlingMethodException;

import javax.servlet.http.HttpServletRequest;
import java.io.File;

/**
 * Controller for the site's help pages
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Controller("helpController")
@RequestMapping(value = "/help")
public class HelpController {
    /** logger */
    private final static Logger logger = Logger.getLogger(HelpController.class);

    /**
     * Enum to reference page paths to their view, with optional skin permission check.
     * Enum value must match the requested filename (case insensitive).
     */
    public enum PageType {
        HELP ("help", null),
        DATA ("data", null),
        PARTNERS ("partners", "avh"),
        LINKS ("links", "avh"),
        ABOUT ("aboutAvh", "avh"),
        CREDITS ("credits", "avh"),
        SPONSORS ("sponsors", "avh"),
        TERMSOFUSE ("termsOfUse", null),
        CONTACTOBIS ("contactObis", "obis"),
        CONTRIBUTING("contributingToObis", "obis"),
        FAQ("obisFaq", "obis");

        protected String viewName;
        protected String skin;
        protected final String viewDirectory = "help";

        PageType(String view, String skin) {
            this.viewName = view;
            this.skin = skin;
        }

        public String getViewName() {
            return viewDirectory + File.separator + viewName;
        }

        public String getSkin() {
            return skin;
        }
    }

    /**
     * Get the requested page with optional check against a valid hub skin
     *
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value = "/{page}", method = RequestMethod.GET)
    public String dynamicPage(@PathVariable("page") String page, HttpServletRequest request) throws NoSuchRequestHandlingMethodException {
        String skin = (String) request.getAttribute("skin");
        PageType pageType = null;
        String view = null;

        try {
            pageType = PageType.valueOf(page.toUpperCase()); // lookup view name via enum
            logger.debug("requested /" + page + " - skin = " + skin + " - view = " + pageType.getViewName());

            if (pageType.getSkin() == null || StringUtils.equalsIgnoreCase(skin, pageType.getSkin())) {
                view = pageType.getViewName();
            }
        } catch (IllegalArgumentException e) {
            logger.warn("Help page not found for: " + page); // filter to 404 exceptions below
        }

        if (view == null) {
            // This exception gets mapped to a 404 by Spring
            throw new NoSuchRequestHandlingMethodException(page, HelpController.class);
        }

        return view;
    }
}
