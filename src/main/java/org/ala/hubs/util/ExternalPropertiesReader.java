/* *************************************************************************
 *  Copyright (C) 2014 Atlas of Living Australia
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
package org.ala.hubs.util;

import org.apache.log4j.Logger;

import javax.servlet.jsp.PageContext;
import java.util.Properties;

/**
 * Load up properties from external properties files and make values
 * available via singleton instance (uses eager initialization).
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public class ExternalPropertiesReader {
    protected static Logger logger = Logger.getLogger(ExternalPropertiesReader.class);
    private static final ExternalPropertiesReader INSTANCE = new ExternalPropertiesReader();

    /** Initialise properties that will be used when no bundle name is provided */
    private Properties props = new Properties();

    private ExternalPropertiesReader() {
        try {
            javax.naming.Context ctx = new javax.naming.InitialContext();
            String filename =(String)ctx.lookup("java:comp/env/configPropFile");
            props.load(new java.io.FileInputStream(new java.io.File(filename)));
            // System.out.println("THE PROPS IN TAG: " + props);
        } catch(Exception e){
            //don't do anything obviously can't find the value
        }
    }

    public static ExternalPropertiesReader getInstance() {
        return INSTANCE;
    }

    public String getPropertyValue(String key) {
        return props.getProperty(key);
    }

    public String getPropertyValue(String key, PageContext pageContext) {
        String value = props.getProperty(key);

        if (value == null) {
            // Check init param
            value = pageContext.getServletContext().getInitParameter(key);
        }

        return value;
    }

}
