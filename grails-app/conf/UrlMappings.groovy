class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/occurrences/search"(controller: 'occurrence', action: 'search')
        "/occurrence/search"(controller: 'occurrence', action: 'search')
        "/occurrence/index"(controller: 'occurrence', action: 'index')
        "/occurrence/legend"(controller: 'occurrence', action: 'legend')
        "/occurrences/$id"(controller: 'occurrence', action: 'show')
        "/occurrence/$id"(controller: 'occurrence', action: 'show')
        "/assertions/$id"(controller: 'occurrence', action: 'assertions')
        "/$action?"(controller:"home")
        "500"(view:'/error')
        "404"(view:'/error')
	}
}
