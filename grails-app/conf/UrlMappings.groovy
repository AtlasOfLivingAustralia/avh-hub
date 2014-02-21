class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/occurrences/search"(controller: 'occurrence', action: 'search')
        "/occurrences/$id"(controller: 'occurrence', action: 'show')
        "/occurrence/$id"(controller: 'occurrence', action: 'show')
        "/"(view:"/index")
        "500"(view:'/error')
        "404"(view:'/error')
	}
}
