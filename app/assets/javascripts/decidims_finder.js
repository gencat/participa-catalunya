/* global instantsearch */

// Replace with your own values
const searchClient = algoliasearch(
  algolia.id,
  algolia.key // search only API key, not admin API key
);

const search = instantsearch({
  indexName: algolia.index,
  searchClient,
  routing: true,
});

search.addWidgets([
  instantsearch.widgets.configure({
    hitsPerPage: 10,
  })
]);

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: '#query',
    placeholder: I18n.participacatalunya.decidims_finder_page.query_placeholder,
    searchAsYouType: true,
    showReset: false,
    showSubmit: false,
    showLoadingIndicator: false,
  })
]);

search.addWidgets([
  instantsearch.widgets.hits({
    container: hits,
    hitsPerPage: 10,
    templates: {
      item: getTemplate('hit'),
      empty: getTemplate('no-results')
    }
  })
]);

search.addWidget(
  instantsearch.widgets.clearRefinements({
    container: '#clear-territory',
    includedAttributes: ['province', 'region', 'municipality'],
    templates: {
      resetLabel: I18n.participacatalunya.decidims_finder_page.clear,
    }
  })
);

search.addWidget(
  instantsearch.widgets.clearRefinements({
    container: '#clear-start_date',
    includedAttributes: ['start_date_timestamp'],
    templates: {
      resetLabel: I18n.participacatalunya.decidims_finder_page.clear,
    }
  })
);

search.addWidget(
  instantsearch.widgets.clearRefinements({
    container: '#clear-end_date',
    includedAttributes: ['end_date_timestamp'],
    templates: {
      resetLabel: I18n.participacatalunya.decidims_finder_page.clear,
    }
  })
);

search.addWidget(
  instantsearch.widgets.stats({
    container: '#stats',
    templates: {
      text: '{{#hasManyResults}}' + I18n.participacatalunya.decidims_finder_page.results + '{{/hasManyResults}}'
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
    }
  })
);

search.addWidget(
  instantsearch.widgets.hierarchicalMenu({
    container: '#territory .panel-body-finder',
    attributes: ['province', 'region', 'municipality'],
    sortBy: function compare(a, b) {
      if (a.name[0] < b.name[0] && b.name != 'Catalunya' || a.name == 'Catalunya') return -1;
      if (a.name[0] > b.name[0] || b.name == 'Catalunya') return 1;
      return 0;
    }
  })
);


search.addWidget(
  datesRange({
    container: "#start_date .panel-body-finder",
    attributeName: 'start_date_timestamp',
    id: "start_date"
  })
);

search.addWidget(
  datesRange({
    container: "#end_date .panel-body-finder",
    attributeName: 'end_date_timestamp',
    id: "end_date"
  })
);

// Event listener to reset the Date Range widgets as they aren't supported by InstantSearch v1.

//Start Date range
document.getElementById("clear-start_date").addEventListener("click", function () {
  document.getElementById("start_date_from").value = ""
  document.getElementById("start_date_from").dispatchEvent(new Event('change'));
  document.getElementById("start_date_to").value = ""
  document.getElementById("start_date_to").dispatchEvent(new Event('change'));
});

//End Date range
document.getElementById("clear-end_date").addEventListener("click", function () {
  document.getElementById("end_date_from").value = ""
  document.getElementById("end_date_from").dispatchEvent(new Event('change'));
  document.getElementById("end_date_to").value = ""
  document.getElementById("end_date_to").dispatchEvent(new Event('change'));
});

function getTemplate(templateName) {
  return document.querySelector('#' + templateName + '-template').innerHTML;
}

search.start();
