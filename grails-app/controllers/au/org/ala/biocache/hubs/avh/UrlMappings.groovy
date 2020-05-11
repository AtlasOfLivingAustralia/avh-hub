package au.org.ala.biocache.hubs.avh

class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller:"home")
        "500"(view:'/error')
        "404"(view:'/error')
        "403"(view:'/error')
	}
}
