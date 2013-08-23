/**************************************************************************
 *  Copyright (C) 2013 Atlas of Living Australia
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

import org.ala.hubs.service.WebService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.supercsv.cellprocessor.ift.CellProcessor;
import org.supercsv.io.CsvListReader;
import org.supercsv.io.ICsvListReader;
import org.supercsv.prefs.CsvPreference;

import javax.inject.Inject;
import java.io.IOException;
import java.io.StringReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller to retrieve ALA data quality information from Google docs spreadsheet
 * at {@linktourl https://docs.google.com/spreadsheet/ccc?key=0AjNtzhUIIHeNdHJOYk1SYWE4dU1BMWZmb2hiTjlYQlE&usp=sharing}
 *
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
@Controller
public class DataQualityInfoController {
    /** Logger initialisation */
    private final static Logger logger = Logger.getLogger(DataQualityInfoController.class);
    @Inject
    private WebService webService;
    @Value("${googleDrive.dataQualityChecks.url}")
    String dataQualityChecksUrl = null; //"https://docs.google.com/spreadsheet/pub?key=0AjNtzhUIIHeNdHJOYk1SYWE4dU1BMWZmb2hiTjlYQlE&single=true&gid=0&output=csv";

    /**
     * JSON web service to return a JSON object for Data Quality Info
     *
     * @return@
     */
    @RequestMapping(value = "/data-quality/allCodes.json")
    public @ResponseBody java.util.Map<String, Object> getDataQualityInfo() throws IOException {
        Map<String, Object> dataQualityCodes = new HashMap<String, Object>();
        String dataQualityCsv = webService.getForUrl(dataQualityChecksUrl);
        ICsvListReader listReader = null;

        try {
            listReader = new CsvListReader(new StringReader(dataQualityCsv), CsvPreference.STANDARD_PREFERENCE);
            listReader.getHeader(true); // skip the header (can't be used with CsvListReader)
            final CellProcessor[] processors = getProcessors();

            List<Object> dataQualityList;
            while ((dataQualityList = listReader.read(processors)) != null ) {
                //logger.debug("row: " + StringUtils.join(dataQualityList, "|"));
                Map<String, String> dataQualityEls = new HashMap<String, String>();
                if (dataQualityList.get(1) != null) {
                    dataQualityEls.put("name", (String) dataQualityList.get(1));
                }
                if (dataQualityList.get(3) != null) {
                    dataQualityEls.put("description", (String) dataQualityList.get(3));
                }
                if (dataQualityList.get(4) != null) {
                    dataQualityEls.put("wiki", (String) dataQualityList.get(4));
                }
                if (dataQualityList.get(0) != null) {
                    dataQualityCodes.put((String) dataQualityList.get(0), dataQualityEls);
                }
            }
        } finally {
            if (listReader != null) {
                listReader.close();
            }
        }

        return dataQualityCodes;
    }

    /**
     * CellProcessor method as required by SuperCSV
     *
     * @return
     */
    private static CellProcessor[] getProcessors() {
        final CellProcessor[] processors = new CellProcessor[] {
                null, // col 1
                null, // col 2
                null, // col 3
                null, // col 4
                null, // col 5
                null, // col 6
                null, // col 7
                null, // col 8
                null, // col 9
                null, // col 10
                null, // col 11
                null, // col 1null
                null, // col 13
                null, // col 14
                null, // col 15
        };

        return processors;
    }

}
