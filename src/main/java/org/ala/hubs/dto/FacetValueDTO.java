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

import org.ala.biocache.dto.FieldResultDTO;

/**
 * Bean to represent a single facet value - adds to FieldResultDTO
 * an additional field "displayLabel"
 *
 * @author Nick dos Remedios (nick.dosremedios@csiro.au)
 */
public class FacetValueDTO extends FieldResultDTO {
    String displayLabel;
    
    public FacetValueDTO(String value, Long count) {
        super(value, count);
        this.displayLabel = value;
    }

    public String getDisplayLabel() {
        return displayLabel;
    }

    public void setDisplayLabel(String displayLabel) {
        this.displayLabel = displayLabel;
    }
}
