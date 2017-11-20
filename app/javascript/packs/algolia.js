const mapStyle = [
    {
        "featureType": "administrative",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#444444"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f2f2f2"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.business",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": 45
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#b4d4e1"
            },
            {
                "visibility": "on"
            }
        ]
    }
];

//calculates distance in km between locations
function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
  if (typeof lat2 == 'undefined'){
    return "";
  }
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  var dLon = deg2rad(lon2-lon1);
  var a =
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
    Math.sin(dLon/2) * Math.sin(dLon/2)
    ;
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  var d = R * c; // Distance in km
  return d;
};

function deg2rad(deg) {
  return deg * (Math.PI/180)
}

// delay the search function until nothing is added to search field for x milliseconds.
// function throttle(f, delay){
//     var timer = null;
//     return function(){
//         var context = this, args = arguments;
//         clearTimeout(timer);
//         timer = window.setTimeout(function(){
//             f.apply(context, args);
//         },
//         delay || 500);
//     };
// }

// When the page loads, search for the search param using algolia search
// $(document).ready(()=> {
//   const params = getParameterByName('search')
//   form.value = params;
//   algoliaSearch();
//   // buildMap();
// });

// Perform algolia search on form after delay
// $(form).keyup(throttle(function(){
//     algoliaSearch();
// }));



//---------------------------------------


const mapSearch = instantsearch({
  appId: '3QRXVE4VDT',
  apiKey: '0448f9b83bca12989799aaf181b86677',
  indexName: 'Product',
  urlSync: true,
  searchParameters:
    {
      aroundLatLngViaIP: true,
      aroundRadius: 5000
    }
});

var mapSearchHits = instantsearch.widgets.hits({
  container: document.querySelector('#hits'),
  hitsPerPage: 20,
  templates: {item:
         `
          <div class="col-xs-12 col-sm-6">
            <div class="card">
              <a class='link-to-product' href='https://got-it-wagon.herokuapp.com/products/{{objectID}}}/'>
                <div class='card-body' style='background-image: url(https://proxy.spigotmc.org/4b123d1a0ba53e5a0ee9982d40de07819a793530?url=http%3A%2F%2Fdazedimg.dazedgroup.netdna-cdn.com%2F786%2Fazure%2Fdazed-prod%2F1150%2F0%2F1150228.jpg)'></div>
                <div class="card-footer">
                  <div class="container">
                    <div class="row">
                      <div class="col-xs-12 col-lg-6">
                        <span class="description">{{name}}</span>
                      </div>
                      <div class="col-xs-12 col-lg-6">
                        <span class="price">£{{price_per_day}}/day</span>
                      </div>
                      <div class="col-xs-12 col-lg-6">
                        <span class="description"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </a>
            </div>
          </div>`
  }
});

var searchBox = instantsearch.widgets.searchBox({
  container: document.querySelector('#searchBox'),
  wrapInput: false
});

var customMapWidget = {
  markers: [],
  _mapContainer: document.querySelector('#map'),
  _hitToMarker: function(hit) {
    return new google.maps.Marker({
      position: {lat: hit._geoloc.lat, lng: hit._geoloc.lng},
      map: this._map,
      title: hit.name
    });
  },
  _handlePlaceChange: function(place) {
    // https://developers.google.com/maps/documentation/javascript/reference#Autocomplete
    var place = this._autocomplete.getPlace();

    if (place.geometry === undefined) {
      // user did not select any place, see https://developers.google.com/maps/documentation/javascript/reference#Autocomplete
      // events paragraph
      if (place.name === '') {
        // input was cleared
        this._helper
          .setQueryParameter('aroundLatLng')
          .search();
      }
      return;
    }

    // see https://developers.google.com/maps/documentation/javascript/reference#PlaceResult
    var latlng = place.geometry.location.toUrlValue();

    // https://www.algolia.com/doc/guides/geo-search/geo-search-overview/#filter-and-sort-around-a-location
    this._helper
      .setQueryParameter('aroundLatLng', latlng)
      .search();
  },
  init: function(params) {
    this._map = new google.maps.Map(this._mapContainer, {zoom: 1, center: new google.maps.LatLng(0, 0), styles: mapStyle});
    this._map.setOptions({ maxZoom: 15, minZoom: 10 });
  },
  render: function(params) {
    // Clear Markers
    this.markers.forEach(function (marker) {
      marker.setMap(null)
    });
    // Transform hits to Google Maps markers
    this.markers = params.results.hits.map(this._hitToMarker.bind(this));

    var bounds = new google.maps.LatLngBounds();

    // Make sure we display the good part of the maps
    this.markers.forEach(function(marker) {
      bounds.extend(marker.getPosition());
    });

    this._map.fitBounds(bounds, 20);
  }
};
mapSearch.addWidget(searchBox);
mapSearch.addWidget(mapSearchHits);
mapSearch.addWidget(customMapWidget);
mapSearch.start();

