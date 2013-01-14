//TODO remove this TEST.  It has been relocated to biocache-service.
//package org.ala.hubs.controller;
//
//import org.ala.hubs.dto.ActiveFacet;
//import org.apache.commons.lang.StringUtils;
//import org.junit.Before;
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//
//import javax.inject.Inject;
//import java.util.Map;
//
//import static org.junit.Assert.assertNotNull;
//import static org.junit.Assert.assertTrue;
//
//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations={"classpath:spring-test.xml"})
//public class FilterQueryParserTest {
//
//    @Inject
//    protected OccurrenceController occurrenceController;
//    protected Map<String, ActiveFacet> facetMap = null;
//
//    @Before
//    public void setUp() throws Exception {
//        String[] fqs = {"species_guid:urn:lsid:biodiversity.org.au:afd.taxon:cdddb387-fca5-48d9-85d2-16357c7b986b",
//                        "collection_uid:co10",
//                        "institution_uid:in4 OR institution_uid:in22 OR institution_uid:in16 OR institution_uid:in6",
//                        "occurrence_year:[1940-01-01T00:00:00Z%20TO%201949-12-31T00:00:00Z]",
//                        "collector:\"Copland, S J\" OR collector:\"Sadlier, R.\" OR collector:\"Mcreaddie, W\" OR collector:\"Rollo, G\" OR collector:\"Harlow, Pete\"",
//                        "month:09 OR month:10 OR month:11"};
//        facetMap = occurrenceController.addFacetMap(fqs);
//    }
//
//    @Test
//    public void testFacetMapInit() {
//        assertNotNull(facetMap);
//    }
//
//    @Test
//    public void testAddFacetMap1() {
//        ActiveFacet sp = facetMap.get("species_guid");
//        assertNotNull(sp);
//        assertTrue(StringUtils.containsIgnoreCase(sp.getValue(), "urn:lsid:biodiversity.org.au:afd.taxon:cdddb387-fca5-48d9-85d2-16357c7b986b"));
//        assertTrue("got: " + sp.getLabel(), StringUtils.containsIgnoreCase(sp.getLabel(), "Species:Pogona barbata"));
//    }
//
//    @Test
//    public void testAddFacetMap2() {
//        ActiveFacet in = facetMap.get("institution_uid");
//        assertNotNull(in);
//        assertTrue(StringUtils.containsIgnoreCase(in.getValue(), "in4 OR institution_uid:in22 OR institution_uid:in16 OR institution_uid:in6"));
//        assertTrue("got: " + in.getLabel(), StringUtils.containsIgnoreCase(in.getLabel(), "Institution:Australian Museum"));
//    }
//
//    @Test
//    public void testAddFacetMap3() {
//        ActiveFacet co = facetMap.get("collection_uid");
//        assertNotNull(co);
//        assertTrue(StringUtils.containsIgnoreCase(co.getValue(), "co10"));
//        assertTrue("got: " + co.getLabel(), StringUtils.containsIgnoreCase(co.getLabel(), "Collection:Australian Museum Herpetology Collection"));
//    }
//
//    @Test
//    public void testAddFacetMap4() {
//        ActiveFacet od = facetMap.get("occurrence_year");
//        assertNotNull(od);
//        assertTrue(StringUtils.containsIgnoreCase(od.getValue(), "[1940-01-01T00:00:00Z%20TO%201949-12-31T00:00:00Z]"));
//        assertTrue("got: " + od.getLabel(), StringUtils.containsIgnoreCase(od.getLabel(), "Date (by decade):1940-1949"));
//    }
//
//    @Test
//     public void testAddFacetMap5() {
//        ActiveFacet col = facetMap.get("collector");
//        assertNotNull(col);
//        assertTrue("got: " + col.getValue(), StringUtils.containsIgnoreCase(col.getValue(), "Copland, S J\" OR collector:\"Sadlier, R.\" OR collector:\"Mcreaddie, W\" OR collector:\"Rollo, G\" OR collector:\"Harlow, Pete"));
//        assertTrue("got: " + col.getLabel(), StringUtils.containsIgnoreCase(col.getLabel(), "Collector:\"Copland, S J\" OR Collector:\"Sadlier, R.\" OR Collector:\"Mcreaddie, W\" OR Collector:\"Rollo, G\" OR Collector:\"Harlow, Pete\""));
//    }
//
//    @Test
//    public void testAddFacetMap6() {
//        ActiveFacet month = facetMap.get("month");
//        assertNotNull(month);
//        assertTrue("got: " + month.getValue(), StringUtils.containsIgnoreCase(month.getValue(), "09 OR month:10 OR month:11"));
//        assertTrue("got: " + month.getLabel(), StringUtils.containsIgnoreCase(month.getLabel(), "Date (by month):September OR Date (by month):October OR Date (by month):November"));
//    }
//}