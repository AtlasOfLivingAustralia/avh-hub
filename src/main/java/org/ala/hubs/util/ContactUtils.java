package org.ala.hubs.util;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestOperations;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * Utilities for dealing with contacts and user roles.
 */
@Component("contactUtils")
public class ContactUtils {

    private final static Logger logger = Logger.getLogger(ContactUtils.class);
    protected String collectoryBaseUrl = "http://collections.ala.org.au";
    protected String collectionContactsUrl = collectoryBaseUrl + "/ws/collection";
    @Inject
    private org.springframework.web.client.RestOperations restTemplate;

    /**
     * Check to see if the user is a collections admin.
     * This is currently done with an email address but this should
     * be phased out in favour of using a CAS ID.
     *
     * @param collectionUid
     * @param userEmail
     * @return true if the user is admin for this collection.
     */
    public boolean isCollectionsAdmin(String collectionUid, String userEmail){
        final String jsonUri = collectionContactsUrl + "/" + collectionUid + "/contacts.json";
        logger.debug("Requesting: " + jsonUri);
        List<Map<String, Object>> contacts = restTemplate.getForObject(jsonUri, List.class);
        logger.debug("number of contacts = " + contacts.size());

        for (Map<String, Object> contact : contacts) {
            Map<String, String> details = (Map<String, String>) contact.get("contact");
            String email = details.get("email");
            logger.debug("email = " + email);
            if (userEmail.equalsIgnoreCase(email)) {
                logger.info("Logged in user has collection admin rights: " + email);
                return true;
            }
        }
        return false;
    }

    public void setCollectoryBaseUrl(String collectoryBaseUrl) {
        this.collectoryBaseUrl = collectoryBaseUrl;
    }

    public void setCollectionContactsUrl(String collectionContactsUrl) {
        this.collectionContactsUrl = collectionContactsUrl;
    }

    public void setRestTemplate(RestOperations restTemplate) {
        this.restTemplate = restTemplate;
    }
}