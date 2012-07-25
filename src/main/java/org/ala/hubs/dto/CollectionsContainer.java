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
package org.ala.hubs.dto;

import org.ala.biocache.util.CollectionsCache;
import org.ala.hubs.service.CollectoryUidCache;
import org.springframework.stereotype.Component;

import javax.inject.Inject;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * Bean to hold cache of collectory codes and names, with check for
 * null values so that cache can be lazily loaded (instead of on startup)
 *
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
@Component("collectionsContainer")
public class CollectionsContainer {
    @Inject
    protected CollectionsCache collectionsCache;
    @Inject
    protected CollectoryUidCache collectoryUidCache;

    private static LinkedHashMap<String, String> collectionMap = null;
    private static LinkedHashMap<String, String> institutionMap = null;
    private static LinkedHashMap<String, String> dataResourceMap = null;
    private static LinkedHashMap<String, String> dataProviderMap = null;

    /**
     * Initialisation method to load cache with values from biocache-service
     */
    public void init() {
        List<String> inguids = collectoryUidCache.getInstitutions();
        List<String> coguids = collectoryUidCache.getCollections();
        collectionMap = collectionsCache.getCollections(inguids, coguids);
        institutionMap = collectionsCache.getInstitutions(inguids, coguids);
        dataResourceMap = collectionsCache.getDataResources(inguids, coguids);
        dataProviderMap = collectionsCache.getDataProviders(inguids, coguids);
    }

    public LinkedHashMap<String, String> getCollectionMap() {
        if (collectionMap == null) {
            init();
        }
        return collectionMap;
    }

    public static void setCollectionMap(LinkedHashMap<String, String> collectionMap) {
        CollectionsContainer.collectionMap = collectionMap;
    }

    public LinkedHashMap<String, String> getInstitutionMap() {
        if (institutionMap == null) {
            init();
        }
        return institutionMap;
    }

    public static void setInstitutionMap(LinkedHashMap<String, String> institutionMap) {
        CollectionsContainer.institutionMap = institutionMap;
    }

    public LinkedHashMap<String, String> getDataResourceMap() {
        if (dataResourceMap == null) {
            init();
        }
        return dataResourceMap;
    }

    public static void setDataResourceMap(LinkedHashMap<String, String> dataResourceMap) {
        CollectionsContainer.dataResourceMap = dataResourceMap;
    }

    public LinkedHashMap<String, String> getDataProviderMap() {
        if (dataProviderMap == null) {
            init();
        }
        return dataProviderMap;
    }

    public static void setDataProviderMap(LinkedHashMap<String, String> dataProviderMap) {
        CollectionsContainer.dataProviderMap = dataProviderMap;
    }
}
