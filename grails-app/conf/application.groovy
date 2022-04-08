// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = "au.org.ala" // change this to alter the default package name and Maven publishing destination

default_config = "/data/${appName}/config/${appName}-config.properties"
if(!grails.config.locations || !(grails.config.locations instanceof List)) {
    grails.config.locations = []
}

/*
def logbackConfigFile = new File("/data/${appName}/config/testst")
println ("Logback config file detected? " + logbackConfigFile.exists())
if (logbackConfigFile.exists()) {
    println("Using test config from " + "/data/${appName}/config/logback.groovy")
    logging.config = "/data/${appName}/config/logback.groovy"
} else {
    println ("test config set from " + logging.config)
}
*/

if (new File(default_config).exists()) {
    println "[${appName}] Including default configuration file: " + default_config;
    grails.config.locations.add "file:" + default_config
} else {
    println "[${appName}] No external configuration file defined."
}

println "[${appName}] (*) grails.config.locations = ${grails.config.locations}"
//println "default_config = ${default_config}"


/******************************************************************************\
 *  CAS SETTINGS
 *
 *  NOTE: Some of these will be ignored if default_config exists
\******************************************************************************/
grails.serverURL = 'http://biocache.ala.org.au'
serverName = 'http://biocache.ala.org.au'
//security.cas.appServerName = "http://biocache.ala.org.au"
//security.cas.casServerName = 'https://auth.ala.org.au'
//security.cas.uriFilterPattern = '/admin, /admin/.*'
//security.cas.authenticateOnlyIfLoggedInPattern = "/occurrences/(?!.+userAssertions|facet.+).+,/explore/your-area"
//security.cas.uriExclusionFilterPattern = '/images.*,/css.*,/js.*'
//security.cas.loginUrl = 'https://auth.ala.org.au/cas/login'
//security.cas.logoutUrl = 'https://auth.ala.org.au/cas/logout'
//security.cas.casServerUrlPrefix = 'https://auth.ala.org.au/cas'
//security.cas.bypass = false // set to true for non-ALA deployment
auth.admin_role = "ROLE_ADMIN"

//security.cas.uriFilterPattern='/admin,/admin/.*,/download,/download/.*,/proxy/.*,/occurrences/.*,/occurrence/.*,/'
//security.cas.uriExclusionFilterPattern='/occurrences/shapeUpload,/images.*,/css.*,/js.*,.*json,/help/.*'
//security.cas.authenticateOnlyIfLoggedInFilterPattern='/occurrences/(?!.+userAssertions|facet.+).+,/explore/your-area,/query,/proxy/download/.*,/'


/*
skin.fluidLayout = true
skin.useAlaSpatialPortal = true
skin.useAlaBie = true
skin.taxaLinks.baseUrl = "http://bie.ala.org.au/species/" // 3rd party species pages. Leave blank for no links
test.var = "ala-hub"
*/

// facets.includeDynamicFacets = true // for sandbox

// The ACCEPT header will not be used for content negotiation for user agents containing the following strings (defaults to the 4 major rendering engines)
grails.mime.disable.accept.header.userAgents = ['Gecko', 'WebKit', 'Presto', 'Trident']
grails.mime.types = [ // the first one is the default format
    all:           '*/*', // 'all' maps to '*' or the first available format in withFormat
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    hal:           ['application/hal+json','application/hal+xml'],
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000


// Legacy setting for codec used to encode data with ${}
grails.views.default.codec = "html"

// The default scope for controllers. May be prototype, session or singleton.
// If unspecified, controllers are prototype scoped.
grails.controllers.defaultScope = 'singleton'

// GSP settings
grails {
    views {
        gsp {
            encoding = 'UTF-8'
            htmlcodec = 'xml' // use xml escaping instead of HTML4 escaping
            codecs {
                expression = 'html' // escapes values inside ${}
                scriptlet = 'html' // escapes output from scriptlets in GSPs
                taglib = 'none' // escapes output from taglibs
                staticparts = 'none' // escapes output from static template parts
            }
        }
        // escapes all not-encoded output at final stage of outputting
        filteringCodecForContentType {
            //'text/html' = 'html'
        }
    }
}

grails.converters.encoding = "UTF-8"
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

environments {
    development {
        serverName = 'http://dev.ala.org.au:8080'
        grails.serverURL = 'http://dev.ala.org.au:8080/' + appName
//        security.cas.appServerName = serverName
//        security.cas.contextPath = "/${appName}"
          //grails.resources.debug = true // cache & resources plugins
    }
    test {
//        grails.serverURL = 'http://130.220.209.134:8080/'
//        serverName='http://130.220.209.134:8080/'
//        security.cas.appServerName = serverName
//        security.cas.contextPath = "/${appName}"

//        security.cas.appServerName = 'http://devt.ala.org.au:8080/'

    }
    production {
//        grails.serverURL = 'http://biocache.ala.org.au'
//        serverName='http://biocache.ala.org.au'
//        security.cas.appServerName = serverName
//        security.cas.contextPath = ""
    }
}

//Restrict sandbox data access to drts by userid or admin
// security.cas.uriFilterPattern=/proxy/.*,/occurrences/.*
// biocache.ajax.useProxy=true
// sandbox.access.restricted=true




/*

grails{
    cache {
        ehcache {
            ehcacheXmlLocation = 'classpath:ehcache.xml'
            lockTimeout = 200 // In milliseconds
        }


    }
}*/
