package org.ala.hubs.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ala.hubs.dto.AssertionDTO;

import au.org.ala.biocache.QualityAssertion;

public class AssertionUtils {

    public static Collection<AssertionDTO> groupAssertions(QualityAssertion[] assertions, String userId){

        //create AssertionDTOs
        Map<Integer, AssertionDTO> grouped = new HashMap<Integer, AssertionDTO>();
        for(QualityAssertion qa : assertions){

            AssertionDTO a = grouped.get(qa.getCode());
            if(a==null){
                a = new AssertionDTO();
                a.setCode(qa.getCode());
                a.setName(qa.getName());
                grouped.put(qa.getCode(), a);
            }
            //add the extra users who have made the same assertion
            a.getUserIds().add(qa.getUserId());
            a.getUserDisplayNames().add(qa.getUserDisplayName());

            if(userId!=null &&  userId.equalsIgnoreCase(qa.getUserId())){
                //this user set this assertion -
                a.setAssertionByUser(true);
                a.setUsersAssertionUuid(qa.getUuid());
            }
        }

        Collection<AssertionDTO> groupedCollection = grouped.values();
        List<AssertionDTO> groupedValues = new ArrayList<AssertionDTO>();
        groupedValues.addAll(groupedCollection);
        Collections.sort(groupedValues, new Comparator<AssertionDTO>() {
            public int compare(AssertionDTO o, AssertionDTO o1) {
                return o.getName().compareTo(o1.getName());
            }
        });
        return groupedValues;
    }
}
