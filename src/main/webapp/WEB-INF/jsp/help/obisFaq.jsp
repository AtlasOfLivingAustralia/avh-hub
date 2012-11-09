<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="hostName" value="${fn:replace(pageContext.request.requestURL, pageContext.request.requestURI, '')}"/>
<c:set var="fullName"><ala:propertyLoader bundle="hubs" property="site.displayName"/></c:set>
<c:set var="shortName"><ala:propertyLoader bundle="hubs" property="site.displayNameShort"/></c:set>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="decorator" content="${skin}"/>
    <meta name="section" content="help"/>
    <title><ala:propertyLoader bundle="hubs" property="site.displayName"/> - Partners </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/help.css" type="text/css" media="screen">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/toc.js"></script>
</head>

<body>
<div id="indentContent">
    <h1>Frequently Asked Questions (FAQ)</h1>
    <div>&nbsp;</div>
    <div class="plain">
        <P><A href="#1">1. What is OBIS?</A> <BR><A href="#2">2. What is meant by "marine species", in the OBIS
            context?</A> <BR><A href="#3">3. What datasets are accessible via the
            OBIS Australia "Data Search"?</A> <BR><A href="#4">4. What is meant by
            the "Australian region", in the present context?</A> <BR><A href="#5">5.
            How is this Data Search different from GBIF Data Searches?</A> <BR><A
                href="#6">6. Why can't I find any data on [<EM>species X</EM>] when
            I search the OBIS system?</A> <BR><A href="#7">7. Is my marine species
            distribution dataset of interest to OBIS?</A> <BR><A href="#8">8. How
            do I set about becoming an OBIS data contributor?</A> <BR><A href="#9">9.
            Can I contribute to the data visualisation tools or related resources available at OBIS Australia?</A>
            <BR><A href="#10">10. What else is happening in the Australian region,
                with regard to access to marine species data?</A> <BR><A
                    href="#11">11. Where can I find more general information about
                the international OBIS system?</A> <BR></P><A name=1></A>


        <P>1. <B>What is OBIS?</B> The Ocean Biogeographic Information System (OBIS) is a web-based provider of global
            geo-referenced information on marine species. It provides a single entry point to query expert databases on
            species and habitats and provides a variety of spatial query tools for visualising relationships among
            marine species and their environment. OBIS is also the information component of the <A
                    href="http://www.coml.org/">Census of Marine Life </A>(CoML), a growing network of researchers in 45
            nations engaged in a 10-year initiative to assess and explain the diversity, distribution, and abundance of
            life in the oceans - past, present, and future. </P>

        <P><A name=2></A><BR>2. <B>What is meant by "marine species", in the OBIS context?</B> For OBIS purposes, marine
            species are animals, plants, and microbes which normally live, or spend a part of their life cycle or
            feeding habits, in the marine environment (also including estuarine or brackish conditions). Some groups
            (examples: echinoderms, corals) are exclusively marine, while others (examples: mammals, birds, reptiles)
            include both marine and non-marine representatives. For groups of the latter type, OBIS attempts to filter
            out the exclusively terrestrial and/or freshwater species from the displayed data, although in some cases
            where habitat preference is not to hand (for example, various algal groups, molluscs, etc.), there may be
            some non-marine representatives included in the data available via OBIS at this time. For birds in
            particular, we follow established practices in including species typically designated "seabirds" (for
            example albatrosses, gulls, penguins, skuas), while excluding other shore birds and waders which are
            normally not allocated to this category. <BR><A name=3></A><BR>3. <B>What datasets are accessible via the
                OBIS Australia "Data Search"?</B> The Data Search functionality accessible from the OBIS Australia
            website searches the holdings of the international OBIS data network. At time of writing (September 2005)
            these comprised some 50 different marine species databases from over 20 different agencies, serving in the
            vicinity of 5 million individual species distribution records (see <A
                    href="http://iobis.org/OBISContributors/obissourcesA">current list</A>). This list is expected to
            grow rapidly over the next few years, as the new network of Regional OBIS Nodes energise content providers
            in their own regions to contribute to the OBIS data network. <BR><A name=4></A><BR>4. <B>What is meant by
                the "Australian region", in the present context?</B> The geographic region of interest for OBIS
            Australia can be loosely defined as extending from the equator at the northern limit to the Antarctic coast,
            with a core coverage from 80 degrees E in the Indian Ocean to 165 degrees E in the Pacific Ocean; these
            "core" longitudinal limits being extended westward to 45 degrees E below 50 degrees S (to encompass the area
            around Heard and McDonald Islands and the westernmost extent of the Australian Antarctic Territory), and
            eastward to 170 degrees E above 40 degrees S (to include Norfolk Island and adjacent portions of the Tasman
            Sea). These approximate limits are indicated on this <A
                    href="http://www.obis.org.au/faq/obis_australia_roi.html">map</A>, and include a (mutually
            agreeable) area of potential overlap with the planned New Zealand OBIS Regional Node. <BR><A name=5></A><BR>5.
            <B>How is this Data Search different from GBIF Data Searches?</B> OBIS and GBIF, the <A
                    href="http://www.gbif.org/">Global Biodiversity Information Facility</A>, have some commonality in
            their mission and available data for online access, but the aspect of the data that is emphasised is
            different for the two systems. For example, the OBIS <A href="http://iobis.org/tech/provider/schemadef1">data
                schema</A> (data fields that can be reported for any record) is extended with respect to the "Darwin
            Core" schema commonly used by data providers to GBIF, to include a number of fields relevant to fisheries
            and marine survey data (Darwin Core was initially devised to suit Museum collections, of largely terrestrial
            data). OBIS also includes an expanding collection of data visualisation tools with a specific marine
            context, for example allowing visualisation against water depth, and other oceanographic parameters.
            <BR><BR>An additional area of difference is that GBIF is built on the basis of national governmental
            contributions, with the expectation that individual countries then contribute relevant data to the master
            system. However, much marine data lies outside national jurisdictional boundaries, and so OBIS is playing a
            role to facilitate the identification and bringing online of such datasets. <BR><BR>OBIS is an associate
            member of GBIF and is already forwarding data contributed to the OBIS network to GBIF so that these points
            too will appear within data searches on the international GBIF portal. <BR><A name=6></A><BR>6. <B>Why can't
                I find any data on [<EM>species X</EM>] when I search for Australian-region data in the OBIS system?</B>
            There are 3 possible reasons for this: either...</P>
        <UL>
            <LI>the species genuinely does not occur here</LI>
            <LI>the species does (or may) occur here, but has not yet been recorded or systematically searched for
                (i.e., incomplete or no sampling)
            </LI>
            <LI>the species does occur here and has been recorded, but relevant records have not yet been connected to
                the OBIS system.
            </LI>
        </UL>
        <P>(There are a few other possibilities, for example you may be searching under an old - or very new - species
            name that is not known to the system, or the name is misspelled, however these are less likely).</P>

        <P>Most commonly, records of the species&nbsp;may exist for the species in our region but have not yet been
            connected to the OBIS network. If you are aware of such records, please see the next question,&nbsp;or
            advise the relevant data custodians to contact us.<BR><A name=7></A><BR>7. <B>Is my marine species
                distribution dataset of interest to OBIS?</B> OBIS is a marine biogeographic information system, meaning
            that we are interested in providing access to datasets that record particular species (or higher taxonomic
            group) from particular marine locations. At present, we can only take information where the locations are
            recorded as latitude and longitude, not as place names. Our focus is on high taxonomic quality, so datasets
            where organisms have been identified by professional or trained biologists are our priority. We also have
            limited staffing, so while we are interested in all data, we may have less time to spend helping those with
            small datasets (a few observations) than we do those with larger or more comprehensive datasets. As a guide,
            if you have a dataset or datasets with more than a few hundred individual marine species records where the
            taxonomic identifications are reliable and the data localities are expressed in latitude and longitude, and
            for which you are happy to provide open access via the OBIS data search access point, we would be interested
            in hearing from you. <BR><A name=8></A><BR>8. <B>How do I set about becoming an OBIS data contributor?</B>
            Information on becoming an OBIS data contributor is available via the "Contributing Data" link in the&nbsp;navigation
            panel on the left of this page. <BR><A name=9></A><BR>9. <B>Can I contribute to the data visualisation tools
                or related resources available at OBIS Australia?</B> That is an option we are certainly open to
            exploring, for example the CMAR <A href="http://www.marine.csiro.au/csquares/">c-squares mapper</A> and
            spatial indexing system has been a contribution by CSIRO Marine and Atmospheric Research (CMAR) to the
            master OBIS system since 2002, and is also used on this OBIS Australia site for click-on-a-map spatial
            searching and for global and regional data mapping. If you have any web-accessible tools that may be of
            interest to either OBIS Australia or the international portal, please contact the <A
                    href="mailto:Tony.Rees@csiro.au">node manager</A>. <BR><A name=10></A><BR>10. <B>What else is
                happening in the Australian region, with regard to access to marine species data?</B> OBIS Australia is
            providing the principal local data access point for marine species distribution data for the Australian
            region. There is a New Zealand Regional OBIS Node under development, hosted by <A
                    href="http://www.niwa.cri.nz/">NIWA</A>, which will have an overlapping area of interest in the
            Tasman Sea and the Southern Ocean. Additional species distribution data, both marine and terrestrial, may
            also be accessible via <A href="http://www.gbif.org/">GBIF</A>, the Global Biodiversity Information
            Facility. <BR><A name=11></A><BR>11. <B>Where can I find more general information about the international
                OBIS system?</B> More general information about the international OBIS system can be found at the <A
                    href="http://www.iobis.org/">international OBIS website</A> and, in particular, at that website's
            own <A href="http://iobis.org/faq/">FAQ page</A>. <BR><BR></P>
    </div>
</div>
</body>
</html> 