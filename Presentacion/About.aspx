<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Presentacion.About" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>
    <h3>Your application description page.</h3>
    <p>Use this area to provide additional information.</p>
    <script>

        function makeSPARQLQuery( endpointUrl, sparqlQuery, doneCallback ) {
	var settings = {
		headers: { Accept: 'application/sparql-results+json' },
		data: { query: sparqlQuery }
	};
	return $.ajax( endpointUrl, settings ).then( doneCallback );
}

var endpointUrl = 'https://query.wikidata.org/sparql',
	sparqlQuery = "SELECT ?pintura ?pinturaLabel ?creador ?creadorLabel ?movimiento ?movimientoLabel ?imagen ?imagenLabel WHERE {\n" +
        "  SERVICE wikibase:label { bd:serviceParam wikibase:language \"[AUTO_LANGUAGE],es\". }\n" +
        "  ?pintura wdt:P31 wd:Q3305213.\n" +
        "  OPTIONAL { ?pintura wdt:P170 ?creador. }\n" +
        "  OPTIONAL { ?pintura wdt:P135 ?movimiento. }\n" +
        "  OPTIONAL { ?pintura wdt:P18 ?imagen. }\n" +
        "}\n" +
        "LIMIT 10";

makeSPARQLQuery( endpointUrl, sparqlQuery, function( data ) {
		$( 'body' ).append( $( '<pre>' ).text( JSON.stringify( data ) ) );
		console.log( data );
	}
);

        function testQuery() {
            var endpoint = "https://query.wikidata.org/sparql";
            var query = "PREFIX bd: <http://www.bigdata.com/rdf#>\n\
PREFIX wikibase: <http://wikiba.se/ontology#>\n\
PREFIX wd: <http://www.wikidata.org/entity/>\n\
PREFIX wdt: <http://www.wikidata.org/prop/direct/>\n\
\n\
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>\n\
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n\
\n\
select\n\
(YEAR(?date) as ?year)\n\
(CONCAT(\'<a href=\\\'\',?link,\'\\\'>\',?label,\'</a>\') as ?html)\n\
?video\n\
    where {\n\
    ?object wdt:P31 wd:Q11424 ;\n\
            wdt:P577 ?date ;\n\
            wdt:P10 ?video ;\n\
            rdfs:label ?label .\n\
\n\
    FILTER (langMatches(lang(?label), \'en\'))\n\
      \n\
    BIND(replace( xsd:string(?object),\n\
    \'http://www.wikidata.org/entity/\',\n\
    \'https://www.wikidata.org/wiki/Special:GoToLinkedPage/frwiki/\') as ?link)\n\
}\n\
ORDER BY ASC(?date)\n\
LIMIT 5"

            // $('#bodyContentResearch').append(queryDataset);
            $.ajax({
                url: endpoint,
                dataType: 'json',
                data: {
                    queryLn: 'SPARQL',
                    query: query,
                    limit: 'none',
                    infer: 'true',
                    Accept: 'application/sparql-results+json'
                },
                success: displayResult,
                error: displayError
            });
        }

        function displayError(xhr, textStatus, errorThrown) {
            console.log(textStatus);
            console.log(errorThrown);
        }

        function displayResult(data) {
            $.each(data.results.bindings, function (index, bs) {
                console.log(bs);
                $("body").append(JSON.stringify(bs) + "<hr/>");
            });
        }

    </script>
</asp:Content>
