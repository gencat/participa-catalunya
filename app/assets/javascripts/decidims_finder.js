/* global instantsearch */

app({
    appId: algolia.id,
    apiKey: algolia.key,
    indexName: algolia.index,
    hitsPerPage : 10
});

/*Instant search functions*/
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
                link: I18n.participacatalunya.decidims_finder_page.clear
            },
        })
    );

    search.addWidget(
        instantsearch.widgets.searchBox({
            container: '#query',
            placeholder: I18n.participacatalunya.decidims_finder_page.query_placeholder,
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
            autoHideContainer: false,
            scrollTo: '#query',
            showFirstLast: true,
            maxpages: 12,
            labels: {
                previous: I18n.participacatalunya.decidims_finder_page.previous,
                next: I18n.participacatalunya.decidims_finder_page.next,
                first: I18n.participacatalunya.decidims_finder_page.first,
                last: I18n.participacatalunya.decidims_finder_page.last
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
        instantsearch.widgets.hierarchicalMenu({
            container: '#territory .panel-body-finder',
            attributes: ['province', 'region', 'municipality'],
            autoHideContainer: false,
            limit: 100,
            operator: 'or',
            sortBy: ['name:asc']
        })
    );


    search.addWidget(
        instantsearch.widgets.datesRange({
            container: "#start_date .panel-body-finder",
            attributeName: 'start_date_timestamp',
            id: "start_date"
        })
    );

    search.addWidget(
        instantsearch.widgets.datesRange({
            container: "#end_date .panel-body-finder",
            attributeName: 'end_date_timestamp',
            id: "end_date"
        })
    );


    // Event listener to reset the Querybox and Date Range widgets as they aren't supported by InstantSearch v1.
    document.getElementById("clear_button").addEventListener("click", function() {
        //Search box
        document.getElementById("query").value = ""
        document.getElementById("query").dispatchEvent(new Event('input'));

        //Data entrada range
        document.getElementById("start_date_from").value = ""
        document.getElementById("start_date_from").dispatchEvent(new Event('change'));
        document.getElementById("start_date_to").value = ""
        document.getElementById("start_date_to").dispatchEvent(new Event('change'));

        //Data resolucio range
        document.getElementById("end_date_from").value = ""
        document.getElementById("end_date_from").dispatchEvent(new Event('change'));
        document.getElementById("end_date_to").value = ""
        document.getElementById("end_date_to").dispatchEvent(new Event('change'));
    });

    search.start();
}

function getTemplate(templateName) {
    return document.querySelector('#' + templateName + '-template').innerHTML;
}
