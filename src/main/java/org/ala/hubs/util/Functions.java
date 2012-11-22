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
package org.ala.hubs.util;

import org.apache.commons.lang.StringEscapeUtils;

/**
 * Custom tag functions for JSP pages
 *
 * @author Nick dos Remedios (Nick.dosRemedios@csiro.au)
 */
public final class Functions {
    private Functions() {
        // don't want this class instantiated!
    }

    /**
     * Custom tag to JS escape String values
     *
     * @param value
     * @return
     */
    public static String escapeJS(String value) {
        return StringEscapeUtils.escapeJavaScript(value);
    }

    /**
     * Emulate the java.lang.String.replaceAll in JSTL
     *
     * @param string
     * @param pattern
     * @param replacement
     * @return
     */
    public static String replaceAll(String string, String pattern, String replacement) {
        return string.replaceAll(pattern, replacement);
    }
}
