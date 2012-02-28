/**************************************************************************
 *  Copyright (C) 2012 Atlas of Living Australia
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
package org.ala.hubs.dto;

/**
 * Simple bean to represent an active facet (filter query)
 *
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
public class ActiveFacet {
    protected String key; // so JSP code is backward compatible with HashMap implementation
    protected String value; // so JSP code is backward compatible with HashMap implementation
    protected String label; // SOLR fields and values can get i18n substitutions
    
    public ActiveFacet() {}
    
    public ActiveFacet(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public ActiveFacet(String key, String value, String label) {
        this.key = key;
        this.value = value;
        this.label = label;
    }

    @Override
    public String toString() {
        return "ActiveFacet{" +
                "key='" + key + '\'' +
                ", value='" + value + '\'' +
                ", label='" + label + '\'' +
                '}';
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }
}
