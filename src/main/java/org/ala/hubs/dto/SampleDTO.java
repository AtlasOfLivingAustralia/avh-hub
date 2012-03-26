package org.ala.hubs.dto;

public class SampleDTO {
    
    protected String layerID;
    protected String layerName;
    protected String layerDisplayName;
    protected String value;    

    public SampleDTO(){}

    public SampleDTO(String layerID, String layerName, String layerDisplayName, String value) {
        this.layerID = layerID;
        this.layerName = layerName;
        this.layerDisplayName = layerDisplayName;
        this.value = value;
    }

    public String getLayerID() {
        return layerID;
    }

    public void setLayerID(String layerID) {
        this.layerID = layerID;
    }

    public String getLayerName() {
        return layerName;
    }

    public void setLayerName(String layerName) {
        this.layerName = layerName;
    }

    public String getLayerDisplayName() {
        return layerDisplayName;
    }

    public void setLayerDisplayName(String layerDisplayName) {
        this.layerDisplayName = layerDisplayName;
    }    
    
    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
