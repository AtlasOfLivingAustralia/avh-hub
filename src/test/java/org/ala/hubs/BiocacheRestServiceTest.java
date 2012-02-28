package org.ala.hubs;

import org.ala.hubs.service.BiocacheService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


import javax.inject.Inject;
import java.util.HashMap;
import java.util.Map;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:src/test/resources/spring-test.xml"})
public class BiocacheRestServiceTest {

    @Inject
    protected BiocacheService biocacheService;

    @Test
    public void testAddAssertion(){

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("code", new Integer(0));
        map.put("comment", "my comment");

        //biocacheService.addAssertion("00000bdb-7734-4d53-aabc-06df24634d9e", map);
    }

    public BiocacheService getBiocacheService() {
        return biocacheService;
    }

    public void setBiocacheService(BiocacheService biocacheService) {
        this.biocacheService = biocacheService;
    }
}