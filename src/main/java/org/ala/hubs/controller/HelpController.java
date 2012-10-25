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


import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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

    /** View name for home page */
    protected String helpPage = "help/help"; // injected via hubs.properties & can be different to HOME_PAGE
    protected String datapage = "help/data"; // injected via hubs.properties & can be different to HOME_PAGE

    /**
     * Help page
     *
     * @return
     */
    @RequestMapping(value = "/help.html", method = RequestMethod.GET)
    public String helpPage(Model model) {
        logger.debug("/help = " + helpPage);
        return helpPage;
    }

    /**
     * Data page
     *
     * @return
     */
    @RequestMapping(value = "/data.html", method = RequestMethod.GET)
    public String dataPage(Model model) {
        logger.debug("/data = " + datapage);
        return datapage;
    }
}
