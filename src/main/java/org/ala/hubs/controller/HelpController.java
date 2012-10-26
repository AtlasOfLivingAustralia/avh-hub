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
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.mvc.multiaction.NoSuchRequestHandlingMethodException;

import javax.servlet.http.HttpServletRequest;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

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
     * Enum to reference page paths to their view, with optional skin permission check
     */
    public enum PageType {
        HELP ("help/help", null),
        DATA ("help/data", null),
        PARTNERS ("help/partners", "avh"),
        LINKS ("help/links", "avh"),
        ABOUT ("help/aboutAvh", "avh"),
        CREDITS ("help/credits", "avh"),
        SPONSORS ("help/sponsors", "avh"),
        TERMSOFUSE ("help/termsOfUse", "avh");

        protected String viewName;
        protected String skin;

        PageType(String view, String skin) {
            this.viewName = view;
            this.skin = skin;
        }

        public String getViewName() {
            return viewName;
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
            logger.debug("requested /" + page + " - skin = " + skin + " - pageType = " + pageType);

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
