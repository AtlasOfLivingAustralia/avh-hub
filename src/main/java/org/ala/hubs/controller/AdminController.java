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

import org.ala.hubs.dto.OutageBanner;
import org.ala.hubs.service.OutageService;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Controller for some admin pages
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Controller("adminController")
@RequestMapping(value = "/admin")
public class AdminController {
    /** logger */
    private final static Logger logger = Logger.getLogger(AdminController.class);
    private static final String SET_OUTAGE = "admin/setOutage";

    @Inject
    OutageService outageService;

    /**
     * InitBinder to provide data conversion when binding
     *
     * @param binder
     */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
    }

    /**
     * Show the admin page oto set an outage message
     *
     * @return
     */
    @RequestMapping(value = "/outageMessage")
    public String getOutageMessage(
            @ModelAttribute OutageBanner outageBanner,
            BindingResult result,
            HttpServletRequest request,
            Model model) throws Exception {

        if (result.hasErrors()) {
            logger.warn("BindingResult errors: " + result.toString());
        }

        logger.debug("/outageMessage method: " + request.getMethod());

        if ("GET".equals(request.getMethod())) {
            // display data from service
            logger.debug("/outageMessage GET: " + outageBanner);
            outageBanner = outageService.getOutageBanner();
        } else {
            // POST - save form data
            logger.debug("/outageMessage POST: " + outageBanner);
            outageService.clearOutageCache(); // clear the cache so changes are instant
            outageService.setOutageBanner(outageBanner);
        }

        model.addAttribute("outageBanner", outageBanner);

        return SET_OUTAGE;
    }

}
