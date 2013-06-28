/* *************************************************************************
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
package org.ala.hubs.dto;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * DTO class for an outage banner to appear on all pages when needed.
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
public class OutageBanner {
    String message;
    @DateTimeFormat(iso=DateTimeFormat.ISO.DATE)
    Date startDate;
    @DateTimeFormat(iso=DateTimeFormat.ISO.DATE)
    Date endDate;
    Boolean showMessage;

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("OutageBanner{");
        sb.append("message='").append(message).append('\'');
        sb.append(", startDate=").append(startDate);
        sb.append(", endDate=").append(endDate);
        sb.append(", showMessage=").append(showMessage);
        sb.append('}');
        return sb.toString();
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Boolean getShowMessage() {
        return showMessage;
    }

    public void setShowMessage(Boolean showMessage) {
        this.showMessage = showMessage;
    }
}
