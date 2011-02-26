package org.ala.hubs.controller;

import org.ala.hubs.service.BiocacheService;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.jasig.cas.client.util.AbstractCasFilter;
import org.jasig.cas.client.validation.Assertion;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller("assertionController")
public class AssertionController {

    @Inject
    private BiocacheService biocacheService;

    /**
     * add an assertion
     */
    @RequestMapping(value = {"/occurrence/{recordUuid}/assertions/add"}, method = RequestMethod.POST)
	public void addAssertion(
       @PathVariable(value="recordUuid") String recordUuid,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {
        String code = (String) request.getParameter("code");
        String comment = (String) request.getParameter("comment");

        System.out.println("User prinicipal: " + request.getUserPrincipal());

        final HttpSession session = request.getSession(false);
        final Assertion assertion = (Assertion) (session == null ? request.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION) : session.getAttribute(AbstractCasFilter.CONST_CAS_ASSERTION));

        if(assertion!=null){
           AttributePrincipal ap = assertion.getPrincipal();
           System.out.println(ap.getName());

           Map<String,Object> properties = new HashMap<String,Object>();
           properties.put("userId", ap.getName());
           properties.put("code", code);
           properties.put("comment", comment);

           biocacheService.addAssertion(recordUuid, code, comment, ap.getName(), "DAVEEEEEEEE");

           response.setStatus(HttpServletResponse.SC_OK);
        } else {
           response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    /**
     * Remove an assertion
     */
    @RequestMapping(value = {"/occurrence/{recordUuid}/assertions/delete"}, method = RequestMethod.POST)
	public void deleteAssertion(
        @PathVariable(value="recordUuid") String recordUuid,
        @RequestParam(value="assertionUuid", required=true) String assertionUuid,
        HttpServletResponse response) throws Exception {

        biocacheService.deleteAssertion(recordUuid, assertionUuid);

        response.setStatus(HttpServletResponse.SC_OK);
    }

    public void setBiocacheService(BiocacheService biocacheService) {
        this.biocacheService = biocacheService;
    }
}
