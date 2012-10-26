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
import au.org.ala.biocache.AssertionQuery;

public class AssertionUtils {

    public static Collection<AssertionDTO> groupAssertions(QualityAssertion[] assertions, AssertionQuery[] queryAssertions, String userId){

        //create AssertionDTOs
        Map<Object, AssertionDTO> grouped = new HashMap<Object, AssertionDTO>();
        if(assertions != null){
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
        }
        
        if(queryAssertions != null){
            for(AssertionQuery aq:queryAssertions){
                AssertionDTO a = grouped.get(aq.assertionType());
                if(a == null){
                    a = new AssertionDTO();                    
                    a.setName(aq.assertionType());
                    grouped.put(a.getName(),a);
                }
                a.getUserIds().add(aq.getUserName());
                if(userId!=null &&  userId.equalsIgnoreCase(aq.getUserName())){
                  //this user set this assertion -
                  a.setAssertionByUser(true);
                  a.setUsersAssertionUuid(aq.getUuid());
              }
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
