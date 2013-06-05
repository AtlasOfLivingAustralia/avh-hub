package org.ala.hubs.controller;

import au.org.ala.biocache.QualityAssertion;
import org.ala.hubs.dto.AssertionDTO;
import org.ala.hubs.service.BiocacheService;
import org.ala.hubs.util.AssertionUtils;
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
import java.util.Map;

@Controller("assertionController")
public class AssertionController {

    private final static Logger logger = Logger.getLogger(AssertionController.class);

    @Inject
    private BiocacheService biocacheService;

    private final String ASSERTIONS =  "occurrences/assertions";
    private final String GROUPED_ASSERTIONS =  "occurrences/groupedAssertions";

    
    @RequestMapping(value={"/occurrences/assertions/add"}, method = RequestMethod.POST)
    public void addAssertionWithParams(
            @RequestParam(value="recordUuid", required=true) String recordUuid,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        addAssertion(recordUuid, request, response);
    }
    
    /**
     * Add an assertion
     */
    @RequestMapping(value = {"/occurrences/{recordUuid}/assertions/add"}, method = RequestMethod.POST)
    public void addAssertion(
       @PathVariable(value = "recordUuid") String recordUuid,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {

        String code = (String) request.getParameter("code");
        String comment = (String) request.getParameter("comment");
        String userDisplayName = (String) request.getParameter("userDisplayName");

        if (comment == null) {
            comment = ""; // avoid NPE when verifying record
        }

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));

        if(assertion != null){

            AttributePrincipal ap = assertion.getPrincipal();
            String userId = (String) ap.getAttributes().get("userid");
            String userEmail = (String) ap.getAttributes().get("email");

            logger.info("Adding assertion to UUID: " + recordUuid
                    + ", code: " + code
                    + ", comment: " + comment
                    + ", userId: " + userId
                    + ", userEmail: " + userEmail
            );

            Map<String,Object> properties = new HashMap<String,Object>();
            properties.put("userId", userId);
            properties.put("userEmail", userEmail);
            properties.put("code", code);
            properties.put("comment", comment);

            logger.info("****** Calling REST service to add assertion" );

            try {
                biocacheService.addAssertion(recordUuid, code, comment, userId, userDisplayName);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write(e.getMessage());
            }

            logger.info("****** Called REST service. Assertion should be added" );

            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            logger.info("****** Unable to add assertions. Login details not accessible." );
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        }
    }
    
    /**
     * Removes an assertion
     * 
     * This version of the method can handle the situation where we use rowKeys as Uuids. Thus
     * URL style rowKeys can be correctly supported.
     * 
     * @param recordUuid
     * @param assertionUuid
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = {"/occurrences/assertions/delete"}, method = RequestMethod.POST)
    public void deleteAssertionWithParams(
            @RequestParam(value="recordUuid", required=true) String recordUuid,
            @RequestParam(value="assertionUuid", required=true) String assertionUuid,
            HttpServletResponse response) throws Exception {
        deleteAssertion(recordUuid, assertionUuid, response);
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
    
    @RequestMapping(value = {"/occurrences/assertions"}, method = RequestMethod.GET)
    public String getUserAssertionsWithParams(
            @RequestParam(value="recordUuid", required=true) String recordUuid,
            HttpServletRequest request,
            Model model) throws Exception {
        return getUserAssertions(recordUuid, request,model);
    }

    /**
     * List all assertions
     */
    @RequestMapping(value = {"/occurrences/{recordUuid}/assertions/"}, method = RequestMethod.GET)
    public String getUserAssertions(@PathVariable(value="recordUuid") String recordUuid,
        HttpServletRequest request,
        Model model) throws Exception {

        logger.debug("(All assertions) User principal: " + request.getUserPrincipal());

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

    @RequestMapping(value = {"/occurrences/groupedAssertions*", "/occurrences/groupedAssertions.json*"}, method = RequestMethod.GET)
    public String getGroupedUserAssertionsWithParams(@RequestParam(value="recordUuid", required=true) String recordUuid,
            HttpServletRequest request,
            Model model)throws Exception {
        return getGroupedUserAssertions(recordUuid, request, model);
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
        if(assertion != null){
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
        //TODO something about the fact that the query assertions are not coming thorugh here...
        Collection<AssertionDTO> groupedAssertions = AssertionUtils.groupAssertions(assertions, null, userId);
        logger.debug("Number of assertions: " + groupedAssertions.size());
        model.addAttribute("assertions", groupedAssertions);
        return GROUPED_ASSERTIONS;
    }

    public void setBiocacheService(BiocacheService biocacheService) {
        this.biocacheService = biocacheService;
    }
}
