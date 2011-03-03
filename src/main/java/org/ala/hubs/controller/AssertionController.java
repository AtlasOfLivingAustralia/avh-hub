package org.ala.hubs.controller;

import au.org.ala.biocache.QualityAssertion;
import org.ala.hubs.dto.AssertionDTO;
import org.ala.hubs.service.BiocacheService;
import org.apache.log4j.Logger;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.jasig.cas.client.util.AbstractCasFilter;
import org.jasig.cas.client.validation.Assertion;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("assertionController")
public class AssertionController {

    private final static Logger logger = Logger.getLogger(AssertionController.class);

    @Inject
    private BiocacheService biocacheService;

    private final String ASSERTIONS =  "occurrences/assertions";
    private final String GROUPED_ASSERTIONS =  "occurrences/groupedAssertions";

    /**
     * add an assertion
     */
    @RequestMapping(value = {"/occurrences/{recordUuid}/assertions/add"}, method = RequestMethod.POST)
	public void addAssertion(
       @PathVariable(value="recordUuid") String recordUuid,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {

        String code = (String) request.getParameter("code");
        String comment = (String) request.getParameter("comment");
        String userId = (String) request.getParameter("userId");
        String userDisplayName = (String) request.getParameter("userDisplayName");

        logger.info("Adding assertion to UUID: "+recordUuid+", code: "+code+", userId: "+ userId );

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));

        if(assertion!=null){
           AttributePrincipal ap = assertion.getPrincipal();
           //System.out.println(ap.getName());

           Map<String,Object> properties = new HashMap<String,Object>();
           properties.put("userId", ap.getName());
           properties.put("code", code);
           properties.put("comment", comment);

           logger.info("******Calling REST service to add assertion" );

           biocacheService.addAssertion(recordUuid, code, comment, ap.getName(), userDisplayName);

           logger.info("******Called REST service. Assertion should be added" );

           response.setStatus(HttpServletResponse.SC_OK);
        } else {

           logger.info("******Unable to add assertions. Login details not accessible." );

           response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    /**
     * Remove an assertion
     */
    @RequestMapping(value = {"/occurrences/{recordUuid}/assertions/delete"}, method = RequestMethod.POST)
	public void deleteAssertion(
        @PathVariable(value="recordUuid") String recordUuid,
        @RequestParam(value="assertionUuid", required=true) String assertionUuid,
        HttpServletResponse response) throws Exception {

        logger.info("******Deleting assertion....from : " +recordUuid);

        biocacheService.deleteAssertion(recordUuid, assertionUuid);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    /**
     * List all assertions
     */
    @RequestMapping(value = {"/occurrences/{recordUuid}/assertions/"}, method = RequestMethod.GET)
	public String getUserAssertions(@PathVariable(value="recordUuid") String recordUuid,
        HttpServletRequest request,
        Model model) throws Exception {

        logger.debug("(All assertions) User prinicipal: " + request.getUserPrincipal());

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));

        if(assertion!=null){
            AttributePrincipal principal = assertion.getPrincipal();
            logger.debug("username = " + principal.getName());
            model.addAttribute("userId", principal.getName());
            String fullName = "";
            if (principal.getAttributes().get("firstname")!=null &&  principal.getAttributes().get("lastname")!=null) {
                fullName = principal.getAttributes().get("firstname").toString() + " " + principal.getAttributes().get("lastname").toString();
            }
            model.addAttribute("userDisplayName", fullName);
        }

        model.addAttribute("recordUuid",recordUuid);
        QualityAssertion[] assertions = biocacheService.getUserAssertions(recordUuid);
        logger.debug("Number of assertions: " + assertions.length);
        model.addAttribute("assertions", assertions);
        return ASSERTIONS;
    }

    /**
     * User assertions grouped by assertion type
     *
     * @param recordUuid
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"/occurrences/{recordUuid}/groupedAssertions/", "/occurrences/{recordUuid}/groupedAssertions.json"}, method = RequestMethod.GET)
	public String getGroupedUserAssertions(@PathVariable(value="recordUuid") String recordUuid,
        HttpServletRequest request,
        Model model) throws Exception {

        logger.debug("(All assertions) User prinicipal: " + request.getUserPrincipal());

        String userId = null;
        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));
        AttributePrincipal principal = null;
        if(assertion!=null){
            principal = assertion.getPrincipal();
            userId = principal.getName();
            logger.debug("username = " + principal.getName());
            model.addAttribute("userId", principal.getName());
            String fullName = "";
            if (principal.getAttributes().get("firstname")!=null &&  principal.getAttributes().get("lastname")!=null) {
                fullName = principal.getAttributes().get("firstname").toString() + " " + principal.getAttributes().get("lastname").toString();
            }
            model.addAttribute("userDisplayName", fullName);
        }

        model.addAttribute("recordUuid",recordUuid);
        QualityAssertion[] assertions = biocacheService.getUserAssertions(recordUuid);

        Collection<AssertionDTO> groupedAssertions = AssertionUtils.groupAssertions(assertions, userId);
        logger.debug("Number of assertions: " + groupedAssertions.size());
        model.addAttribute("assertions", groupedAssertions);
        return GROUPED_ASSERTIONS;
    }


    public void setBiocacheService(BiocacheService biocacheService) {
        this.biocacheService = biocacheService;
    }
}
