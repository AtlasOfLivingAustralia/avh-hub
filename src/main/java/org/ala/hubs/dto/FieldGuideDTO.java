package org.ala.hubs.dto;

import java.util.ArrayList;
import java.util.List;

public class FieldGuideDTO {

    protected List<String> guids = new ArrayList<String>();
    protected String title = "";
    protected String link = "";

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public List<String> getGuids() {
        return guids;
    }

    public void setGuids(List<String> guids) {
        this.guids = guids;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
