/* *************************************************************************
 *  Copyright (C) 2011 Atlas of Living Australia
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

import java.util.ArrayList;
import org.apache.commons.lang.StringUtils;

/**
 * Request parameters for the advanced search form (form backing bean)
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public class AdvancedSearchParams {

    protected String text = "";
    protected String[] lsid = {};
    protected String[] taxa = {};
    protected String raw_taxon_name = "";
    protected String species_group = "";
    protected String institution_collection = "";
    protected String state = "";
    protected String country = "";    
    protected String ibra = "";
    protected String imcra = "";
    protected String places = "";
    protected String type_status = "";
    protected String basis_of_record = "";
    protected String catalogue_number = "";
    protected String record_number = "";
    protected String collector = "";
    protected String start_date = "";
    protected String end_date = "";

    /**
     * This custom toString method outputs a valid SOLR query (q param value).
     * 
     * @return q
     */
    @Override
    public String toString() {
        StringBuilder q = new StringBuilder();
        
        if (!text.isEmpty()) q.append("text:").append(text);
        if (!raw_taxon_name.isEmpty()) q.append(" raw_taxon_name:\"").append(raw_taxon_name).append("\"");
        if (!species_group.isEmpty()) q.append(" species_group:").append(species_group);
        if (!state.isEmpty()) q.append(" state:\"").append(state).append("\"");
        if (!state.isEmpty()) q.append(" country:\"").append(country).append("\"");        
        if (!ibra.isEmpty()) q.append(" ibra:\"").append(ibra).append("\"");
        if (!imcra.isEmpty()) q.append(" imcra:\"").append(imcra).append("\"");
        if (!places.isEmpty()) q.append(" places:\"").append(places.trim()).append("\"");
        if (!type_status.isEmpty()) q.append(" type_status:").append(type_status);
        if (!basis_of_record.isEmpty()) q.append(" basis_of_record:").append(basis_of_record);
        if (!catalogue_number.isEmpty()) q.append(" catalogue_number:").append(catalogue_number);
        if (!record_number.isEmpty()) q.append(" record_number:").append(record_number);
        if (!collector.isEmpty()) q.append(" collector:").append(collector);
        
        ArrayList<String> lsids = new ArrayList<String>();
        ArrayList<String> taxas = new ArrayList<String>();
        
        // iterate over the taxa search inputs and if lsid is set use it otherwisw use taxa input
        for (int i = 0; i < lsid.length; i++) {
            if (!lsid[i].isEmpty()) {
                lsids.add(lsid[i]);
            } else if (!taxa[i].isEmpty()) {
                taxas.add(taxa[i]);
            }
        }
        
        if (!lsids.isEmpty()) {
            q.append(" lsid:").append(StringUtils.join(lsids, " OR lsid:"));
        }
        
        if (!taxas.isEmpty()) {
            if (!lsids.isEmpty()) q.append(" OR ");
            q.append(" taxon_name:\"").append(StringUtils.join(taxas, "\" OR taxon_name:\"")).append("\"");
        }
        
        if (!institution_collection.isEmpty()) {
            String label = (StringUtils.startsWith(institution_collection, "in")) ? " institution_uid" : " collection_uid";
            q.append(label).append(":").append(institution_collection);
        }
        
        if (!start_date.isEmpty() || !end_date.isEmpty()) {
            String value = "";
            if (!start_date.isEmpty()) {
                value = "[" + start_date + "T12:00:00Z TO ";
            } else {
                value = "[* TO ";
            }
            if (!end_date.isEmpty()) {
                value = value + end_date + "T12:00:00Z]";
            } else {
                value = value + "*]";
            }
            q.append(" occurrence_date:").append(value);
        }
        
        return q.toString().trim();
    }

    /**
     * Get the value of end_date
     *
     * @return the value of end_date
     */
    public String getEnd_date() {
        return end_date;
    }

    /**
     * Set the value of end_date
     *
     * @param end_date new value of end_date
     */
    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }

    /**
     * Get the value of start_date
     *
     * @return the value of start_date
     */
    public String getStart_date() {
        return start_date;
    }

    /**
     * Set the value of start_date
     *
     * @param startDate new value of start_date
     */
    public void setStart_date(String startDate) {
        this.start_date = startDate;
    }

    /**
     * Get the value of collector
     *
     * @return the value of collector
     */
    public String getCollector() {
        return collector;
    }

    /**
     * Set the value of collector
     *
     * @param collector new value of collector
     */
    public void setCollector(String collector) {
        this.collector = collector;
    }

    /**
     * Get the value of record_number
     *
     * @return the value of record_number
     */
    public String getRecord_number() {
        return record_number;
    }

    /**
     * Set the value of record_number
     *
     * @param record_number new value of record_number
     */
    public void setRecord_number(String record_number) {
        this.record_number = record_number;
    }

    /**
     * Get the value of catalogue_number
     *
     * @return the value of catalogue_number
     */
    public String getCatalogue_number() {
        return catalogue_number;
    }

    /**
     * Set the value of catalogue_number
     *
     * @param catalogue_number new value of catalogue_number
     */
    public void setCatalogue_number(String catalogue_number) {
        this.catalogue_number = catalogue_number;
    }

    /**
     * Get the value of basis_of_record
     *
     * @return the value of basis_of_record
     */
    public String getBasis_of_record() {
        return basis_of_record;
    }

    /**
     * Set the value of basis_of_record
     *
     * @param basis_of_record new value of basis_of_record
     */
    public void setBasis_of_record(String basis_of_record) {
        this.basis_of_record = basis_of_record;
    }

    /**
     * Get the value of type_status
     *
     * @return the value of type_status
     */
    public String getType_status() {
        return type_status;
    }

    /**
     * Set the value of type_status
     *
     * @param type_status new value of type_status
     */
    public void setType_status(String type_status) {
        this.type_status = type_status;
    }

    /**
     * Get the value of places
     *
     * @return the value of places
     */
    public String getPlaces() {
        return places;
    }

    /**
     * Set the value of places
     *
     * @param places new value of places
     */
    public void setPlaces(String places) {
        this.places = places;
    }

    /**
     * Get the value of imcra
     *
     * @return the value of imcra
     */
    public String getImcra() {
        return imcra;
    }

    /**
     * Set the value of imcra
     *
     * @param imcra new value of imcra
     */
    public void setImcra(String imcra) {
        this.imcra = imcra;
    }

    /**
     * Get the value of ibra
     *
     * @return the value of ibra
     */
    public String getIbra() {
        return ibra;
    }

    /**
     * Set the value of ibra
     *
     * @param ibra new value of ibra
     */
    public void setIbra(String ibra) {
        this.ibra = ibra;
    }

    /**
     * Get the value of state
     *
     * @return the value of state
     */
    public String getState() {
        return state;
    }

    /**
     * Set the value of state
     *
     * @param state new value of state
     */
    public void setState(String state) {
        this.state = state;
    }

    /**
     * Get the value of institution_collection
     *
     * @return the value of institution_collection
     */
    public String getInstitution_collection() {
        return institution_collection;
    }

    /**
     * Set the value of institution_collection
     *
     * @param institution_collection new value of institution_collection
     */
    public void setInstitution_collection(String institution_collection) {
        this.institution_collection = institution_collection;
    }

    /**
     * Get the value of species_group
     *
     * @return the value of species_group
     */
    public String getSpecies_group() {
        return species_group;
    }

    /**
     * Set the value of species_group
     *
     * @param species_group new value of species_group
     */
    public void setSpecies_group(String species_group) {
        this.species_group = species_group;
    }

    /**
     * Get the value of raw_taxon_name
     *
     * @return the value of raw_taxon_name
     */
    public String getRaw_taxon_name() {
        return raw_taxon_name;
    }

    /**
     * Set the value of raw_taxon_name
     *
     * @param raw_taxon_name new value of raw_taxon_name
     */
    public void setRaw_taxon_name(String raw_taxon_name) {
        this.raw_taxon_name = raw_taxon_name;
    }

    /**
     * Get the value of lsid
     *
     * @return the value of lsid
     */
    public String[] getLsid() {
        return lsid;
    }

    /**
     * Set the value of lsid
     *
     * @param lsid new value of lsid
     */
    public void setLsid(String[] lsid) {
        this.lsid = lsid;
    }

    /**
     * Get the value of text
     *
     * @return the value of text
     */
    public String getText() {
        return text;
    }

    /**
     * Set the value of text
     *
     * @param text new value of text
     */
    public void setText(String text) {
        this.text = text;
    }

    public String[] getTaxa() {
        return taxa;
    }

    public void setTaxa(String[] taxa) {
        this.taxa = taxa;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }
}
