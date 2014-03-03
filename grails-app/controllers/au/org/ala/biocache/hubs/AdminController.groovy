/*
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

import grails.plugin.cache.CacheEvict

class AdminController {
    def scaffold = true

    def index() {
        render "Not available to the public"
    }

    @CacheEvict(value='biocacheCache', allEntries=true)
    def clearBiocacheCache() {
        render(text:"biocacheCache cache cleared")
    }

    @CacheEvict(value='collectoryCache', allEntries=true)
    def clearCollectoryCache() {
        render(text:"collectoryCache cache cleared")
    }

    @CacheEvict(value='longTermCache', allEntries=true)
    def clearLongTermCache() {
        render(text:"longTermCache cache cleared")
    }
}
