package org.ala.hubs.spring;

import java.util.Properties;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.naming.InitialContext;
import javax.naming.NameNotFoundException;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

/**
 * A custom properties loader that uses a value in the web.xml to determine the filename to use.
 * 
 * @author Natasha Carter (natasha.carter@csiro.au)
 *
 */
@Component("hubsProperties")
public class HubsProperties extends Properties implements InitializingBean {
    private final static Logger logger = Logger.getLogger(HubsProperties.class);
    private String fileName="/data/hubs/config/hubs-config.properties";
    public HubsProperties(){
        
    }
   
    public void init() throws Exception {
        javax.naming.Context env = (javax.naming.Context)new InitialContext().lookup("java:comp/env");
        try{
            fileName = (String)env.lookup("configPropFile");
        } catch(NameNotFoundException e){
            //use the default value for the hubs property file
        }
        
        logger.info("The configPropFile: " + fileName);
        //now initialise the properties
        java.io.File file = new java.io.File(fileName);
        if(file.exists()){
            load(new java.io.FileInputStream(file));
        } else{
            logger.error("Unable to locate the configPropFile to use " + fileName + ". Please ensure the file exists.");
        }
        logger.info("The HUBS properties: " +this);
    }
    /**
     * @return the fileName
     */
    public String getFileName() {
        return fileName;
    }
    /**
     * @param fileName the fileName to set
     */
    public void setFileName(String fileName) {
        
        this.fileName = fileName;
    }
    @Override
    public void afterPropertiesSet() throws Exception {        
        logger.debug("HUB Proeprties are set ");
        logger.debug("Properties file " + fileName);
        init();
       
    }
    
}
