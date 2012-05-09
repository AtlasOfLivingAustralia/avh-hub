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

import java.net.URLEncoder;
import java.util.ArrayList;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

/**
 * Request parameters for the advanced search form (form backing bean)
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public class AdvancedSearchParams {
    private final static Logger logger = Logger.getLogger(AdvancedSearchParams.class);
    
    protected String text = "";
    protected String taxa = "";
    protected String[] lsid = {};  // deprecated 
    protected String[] taxonText = {};
    protected String nameType = "";
    protected String raw_taxon_name = "";
    protected String species_group = "";
    protected String institution_collection = "";
    protected String state = "";
    protected String country = "";    
    protected String ibra = "";
    protected String imcra = "";
    protected String imcra_meso = "";
    protected String places = "";
    protected String cl959 = "";
    protected String type_status = "";
    protected Boolean type_material = false;
    protected String basis_of_record = "";
    protected String catalogue_number = "";
    protected String record_number = "";
    protected String collector = "";
    protected String collectors_number = "";
    protected String identified_by = "";
    protected String identified_date_start = "";
    protected String identified_date_end = "";
    protected String cultivation_status = "";
    protected String loan_destination = "";
    protected String duplicate_inst = "";
    protected String loan_identifier = "";
    protected String start_date = "";
    protected String end_date = "";
    protected String last_load_start = "";
    protected String last_load_end = "";
    
    private final String QUOTE = "\"";

    /**
     * This custom toString method outputs a valid SOLR query (q param value).
     * 
     * @return q
     */
    @Override
    public String toString() {
        StringBuilder q = new StringBuilder();
        // build up q from the simple fields first...
        if (!text.isEmpty()) q.append("text:").append(text);
        if (!raw_taxon_name.isEmpty()) q.append(" raw_name:").append(quoteText(raw_taxon_name));
        if (!species_group.isEmpty()) q.append(" species_group:").append(species_group);
        if (!state.isEmpty()) q.append(" state:").append(quoteText(state));
        if (!country.isEmpty()) q.append(" country:").append(quoteText(country));
        if (!ibra.isEmpty()) q.append(" ibra:").append(quoteText(ibra));
        if (!imcra.isEmpty()) q.append(" imcra:").append(quoteText(imcra));
        if (!imcra_meso.isEmpty()) q.append(" cl966:").append(quoteText(imcra_meso));
        if (!cl959.isEmpty()) q.append(" cl959:").append(quoteText(cl959));
        if (!places.isEmpty()) q.append(" places:").append(quoteText(places.trim()));
        if (!type_status.isEmpty()) q.append(" type_status:").append(type_status);
        if (type_material) q.append(" type_status:").append("*");
        if (!basis_of_record.isEmpty()) q.append(" basis_of_record:").append(basis_of_record);
        if (!catalogue_number.isEmpty()) q.append(" catalogue_number:").append(quoteText(catalogue_number));
        if (!record_number.isEmpty()) q.append(" record_number:").append(record_number);
        if (!cultivation_status.isEmpty()) q.append(" establishment_means:").append(cultivation_status);
        if (!collector.isEmpty()) q.append(" collector_text:").append(quoteText(collector));
        if (!identified_by.isEmpty()) q.append(" identified_by_text:").append(quoteText(identified_by));
        if (!loan_destination.isEmpty()) q.append(" loan_destination:").append(loan_destination);
        if (!loan_identifier.isEmpty()) q.append(" loan_identifier:").append(loan_identifier);
        if (!duplicate_inst.isEmpty()) q.append(" duplicate_inst:").append(duplicate_inst);
        //if (!collectors_number.isEmpty()) q.append(" collector:").append(collectors_number); // TODO field in SOLR not active
        
        ArrayList<String> lsids = new ArrayList<String>();
        ArrayList<String> taxas = new ArrayList<String>();
        
        // iterate over the taxa search inputs and if lsid is set use it otherwise use taxa input
        for (int i = 0; i < taxonText.length; i++) {
            if (!taxonText[i].isEmpty()) {
                taxas.add(quoteText(taxonText[i])); // taxonText[i].replaceAll(" ", "+")
            }
        }

        // if more than one taxa query, add braces so we get correct Boolean precedence
        String[] braces = {"",""};
        if (taxas.size() > 1) {
            braces[0] = "(";
            braces[1] = ")";
        }
        
        if (!taxas.isEmpty()) {
            // build up OR'ed taxa query with braces if more than one taxon
            q.append(" ").append(braces[0]).append(nameType).append(":");
            q.append(StringUtils.join(taxas, " OR " + nameType + ":")).append(braces[1]);
        }

        // TODO: deprecate this code (?)
        if (!lsids.isEmpty()) {
            q.append(" lsid:").append(StringUtils.join(lsids, " OR lsid:"));
        }

        if (!institution_collection.isEmpty()) {
            String label = (StringUtils.startsWith(institution_collection, "in")) ? " institution_uid" : " collection_uid";
            q.append(label).append(":").append(institution_collection);
        }
        
        if (!start_date.isEmpty() || !end_date.isEmpty()) {
            String value = combineDates(start_date, end_date);
            q.append(" occurrence_date:").append(value);
        }

        if (!last_load_start.isEmpty() || !last_load_end.isEmpty()) {
            String value = combineDates(last_load_start, last_load_end);
            q.append(" modified_date:").append(value);
        }

        if (!identified_date_start.isEmpty() || !identified_date_end.isEmpty()) {
            String value = combineDates(identified_date_start, identified_date_end);
            q.append(" identified_date:").append(value);
        }

        String finalQuery = "";

        if (!taxa.isEmpty()) {
            String query = URLEncoder.encode(q.toString().replace("?", ""));
            finalQuery = "taxa=" + taxa + "&q=" + query;
        } else {
            finalQuery = "q=" + URLEncoder.encode(q.toString().trim()); // TODO: use non-deprecated version with UTF-8
        }
        logger.debug("query: " + finalQuery);
        return finalQuery;
    }

    /**
     * Combine two dates [YYYY-MM-DD] into a SOLR date range String
     *
     * @param startDate
     * @param endDate
     * @return
     */
    private String combineDates(String startDate, String endDate) {
        logger.info("dates check: " + startDate + "|" + endDate);
        String value = "";
        // TODO check input dates are valid
        if (!startDate.isEmpty()) {
            value = "[" + startDate + "T00:00:00Z TO ";
        } else {
            value = "[* TO ";
        }
        if (!endDate.isEmpty()) {
            value = value + endDate + "T00:00:00Z]";
        } else {
            value = value + "*]";
        }
        return value;
    }

    /**
     * Surround phrase search with quotes
     * 
     * @param text
     * @return 
     */
    private String quoteText(String text) {
        if (StringUtils.contains(text, " ")) {
            text = QUOTE + text + QUOTE;
        }
        
        return text;
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

    public String[] getTaxonText() {
        return taxonText;
    }

    public void setTaxonText(String[] taxonText) {
        this.taxonText = taxonText;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getNameType() {
        return nameType;
    }

    public void setNameType(String nameType) {
        this.nameType = nameType;
    }

    public String getCollectors_number() {
        return collectors_number;
    }

    public void setCollectors_number(String collectors_number) {
        this.collectors_number = collectors_number;
    }

    public Boolean getType_material() {
        return type_material;
    }

    public void setType_material(Boolean type_material) {
        this.type_material = type_material;
    }

    public String getLast_load_start() {
        return last_load_start;
    }

    public void setLast_load_start(String last_load_start) {
        this.last_load_start = last_load_start;
    }

    public String getLast_load_end() {
        return last_load_end;
    }

    public void setLast_load_end(String last_load_end) {
        this.last_load_end = last_load_end;
    }

    public String getTaxa() {
        return taxa;
    }

    public void setTaxa(String taxa) {
        this.taxa = taxa;
    }

    public String getLoan_destination() {
        return loan_destination;
    }

    public void setLoan_destination(String loan_destination) {
        this.loan_destination = loan_destination;
    }

    public String getLoan_identifier() {
        return loan_identifier;
    }

    public void setLoan_identifier(String loan_identifier) {
        this.loan_identifier = loan_identifier;
    }

    public String getDuplicate_inst() {
        return duplicate_inst;
    }

    public void setDuplicate_inst(String duplicate_inst) {
        this.duplicate_inst = duplicate_inst;
    }

    public String getCultivation_status() {
        return cultivation_status;
    }

    public void setCultivation_status(String cultivation_status) {
        this.cultivation_status = cultivation_status;
    }

    public String getIdentified_by() {
        return identified_by;
    }

    public void setIdentified_by(String identified_by) {
        this.identified_by = identified_by;
    }

    public String getIdentified_date_start() {
        return identified_date_start;
    }

    public void setIdentified_date_start(String identified_date_start) {
        this.identified_date_start = identified_date_start;
    }

    public String getIdentified_date_end() {
        return identified_date_end;
    }

    public void setIdentified_date_end(String identified_date_end) {
        this.identified_date_end = identified_date_end;
    }

    public String getImcra_meso() {
        return imcra_meso;
    }

    public void setImcra_meso(String imcra_meso) {
        this.imcra_meso = imcra_meso;
    }

    public String getCl959() {
        return cl959;
    }

    public void setCl959(String cl959) {
        this.cl959 = cl959;
    }
}
