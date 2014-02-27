/* *************************************************************************
 * Copyright (C) 2014 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */

package au.org.ala.biocache.hubs

class MessagesController {
    def messageSource // ExtendedPluginAwareResourceBundleMessageSource
    static defaultAction = "i18n"

    /**
     * Export raw i18n message properties as TEXT for use by JavaScript i18n library
     *
     * @param id - locale string, e.g. en, es, en_US or es_ES
     * @return
     */
    def i18n(String id) {
        Locale locale = request.locale

        if (id) {
            List locBits = id?.tokenize('_')
            locale = new Locale(locBits[0], locBits[1]?:'')
        }

        Map props = messageSource.listMessageCodes(locale?:request.locale)
        //log.debug "props = ${props}"
        response.setHeader("Content-type", "text/plain")
        render ( text: props.collect{ "${it.key}=${it.value}" }.join("\n") )
    }
}
