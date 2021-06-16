/* global instantsearch */

//CHANGE ME!
app({
    appId: 'YIQONPL50S',
    apiKey: 'bdb6aa5a3997de1fa9aecbade22f7e44',
    indexName: '3161_PRO_SAIP',
    hitsPerPage : 10
});

/* Funcions per a l'instant search*/
function app(opts) {

    opts.urlSync = {
        trackedParameters: ['query', 'attribute:*', 'page']
    };

    opts.searchFunction = function (helper) {
        /* ================================================================
           SET HERE YOUR SEARCH API PARAMS (helper.state)
           https://www.algolia.com/doc/api-reference/search-api-parameters/
           ================================================================ */
        helper.state.typoTolerance = false;

        helper.search();
    };

    var search = instantsearch(opts);

    search.addWidget(
        instantsearch.widgets.hits({
            container: hits,
            hitsPerPage: 10,
            templates: {
                item: getTemplate('hit'),
                empty: getTemplate('no-results')
            },
            transformData: function (item) {
                return item;
            }
        })
    );

    search.addWidget(
        instantsearch.widgets.clearAll({
            container: '#clear_button',
            autoHideContainer: false,
            clearsQuery: true,
            templates: {
                link: 'Neteja filtres'
            },
        })
    );

    search.addWidget(
        instantsearch.widgets.searchBox({
            container: '#query',
            placeholder: 'Cerca sol·licitud...',
            reset: false,
            magnifier: false
        })
    );

    search.addWidget(
        instantsearch.widgets.stats({
            container: '#stats',
            templates: {
                body: getTemplate('stats')
            },
            transformData: function (item) {
                item.nbHits = new Intl.NumberFormat('ca-ES').format(item.nbHits);
                return item;
            }
        })
    );

    search.addWidget(
        instantsearch.widgets.pagination({
            container: '#pagination',
            autoHideContainer: true,
            scrollTo: '#query',
            showFirstLast: true,
            maxpages: 10,
            labels: {
                previous: "anterior",
                next: "següent",
                first: "primera",
                last: "última"
            },
            cssClasses: {
                first: "hidden-xs",
                last: "hidden-xs",
                page: "hidden-xs"
            },
            transformData: function (item) {
                return item;
            }
        })
    );


    search.addWidget(
        instantsearch.widgets.refinementList({
            container: '#tematica .panel-body-cercador',
            attributeName: 'tem_tica',
            autoHideContainer: true,
            limit: 100,
            operator: 'or',
            sortBy: ['name:asc']
        })
    );

    search.addWidget(
        instantsearch.widgets.refinementList({
            container: '#info_generica .panel-body-cercador',
            attributeName: 'tipologia_informaci_gen_rica',
            autoHideContainer: true,
            limit: 100,
            operator: 'or',
            sortBy: ['name:asc']
        })
    );


    search.addWidget(
        instantsearch.widgets.refinementList({
            container: '#info_especifica .panel-body-cercador',
            attributeName: 'tipologia_informaci_espec_fica',
            autoHideContainer: true,
            limit: 100,
            operator: 'or',
            sortBy: ['name:asc']
        })
    );

    search.addWidget(
        instantsearch.widgets.refinementList({
            container: '#tipus_resolucio .panel-body-cercador',
            attributeName: 'tipus_de_resoluci',
            autoHideContainer: true,
            limit: 100,
            operator: 'or',
            sortBy: ['name:asc']
        })
    );

    search.addWidget(
        instantsearch.widgets.datesRange({
            container: "#data_entrada .panel-body-cercador",
            attributeName: 'timestamp_entrada',
            id: "data_entrada"
        })
    );

    search.addWidget(
        instantsearch.widgets.datesRange({
            container: "#data_resolucio .panel-body-cercador",
            attributeName: 'timestamp_resolucio',
            id: "data_resolucio"
        })
    );

    // Event listener to reset the Querybox and Date Range widgets as they aren't supported by InstantSearch v1.
    document.getElementById("clear_button").addEventListener("click", function() {
        //Search box
        document.getElementById("query").value = ""
        document.getElementById("query").dispatchEvent(new Event('input'));

        //Data entrada range
        document.getElementById("data_entrada_from").value = ""
        document.getElementById("data_entrada_from").dispatchEvent(new Event('change'));
        document.getElementById("data_entrada_to").value = ""
        document.getElementById("data_entrada_to").dispatchEvent(new Event('change'));

        //Data resolucio range
        document.getElementById("data_resolucio_from").value = ""
        document.getElementById("data_resolucio_from").dispatchEvent(new Event('change'));
        document.getElementById("data_resolucio_to").value = ""
        document.getElementById("data_resolucio_to").dispatchEvent(new Event('change'));
    });

    search.start();
}

function getTemplate(templateName) {
    return document.querySelector('#' + templateName + '-template').innerHTML;
}
