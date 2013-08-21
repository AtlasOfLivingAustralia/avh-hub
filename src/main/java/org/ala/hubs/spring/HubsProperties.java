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
        //System.out.println("PPPPP: Started...");
    }
   
    public void init() throws Exception {
        javax.naming.Context env = (javax.naming.Context)new InitialContext().lookup("java:comp/env");
        try{
            fileName = (String)env.lookup("configPropFile");
        } catch(NameNotFoundException e){
            //use the default value for the hubs property file
        }
        
        logger.info("propFile::: " + fileName);
        //now initialise the properties
        java.io.File file = new java.io.File(fileName);
        if(file.exists()){
            load(new java.io.FileInputStream(file));
        }
        logger.info("MY PROPERTIES:::: " +this);
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
        // TODO Auto-generated method stub
        logger.debug("HUB Proeprties are set ");
        logger.debug("Properties file " + fileName);
        init();
       
    }
    
}
