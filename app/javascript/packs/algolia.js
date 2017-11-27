let userLat;
let userLng;
let productLat;
let productLng;
let products = [];
let distanceInKm = [];
let counter = 0;
let defaultSearchRadius = 5000;
let searchPrecision = {};
var client = algoliasearch("3QRXVE4VDT", "0448f9b83bca12989799aaf181b86677");
var index = client.initIndex('Product');

const searchRadius = document.getElementById('searchDistance')
searchRadius.addEventListener('keyup', throttle(function(){
  if (searchRadius.value == 0){
    defaultSearchRadius = 5000;
  }else {
    defaultSearchRadius = searchRadius.value*1000;
  }
// mapSearch.addWidget(searchBox);
// mapSearch.addWidget(mapSearchHits);
// mapSearch.addWidget(customMapWidget);
// mapSearch.start();
// console.log(defaultSearchRadius);
}));


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

setProductCount = () => {
  var counter = document.getElementById('counter');
  counter.innerHTML = `${products.length} Search results in your area...`;
}

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
  var rounded = Math.round( d * 10 ) / 10;
  return rounded;
};

function deg2rad(deg) {
  return deg * (Math.PI/180)
}

const mapSearch = instantsearch({
  appId: '3QRXVE4VDT',
  apiKey: '0448f9b83bca12989799aaf181b86677',
  indexName: 'Product',
  urlSync: true,
  searchParameters:
    {
      aroundLatLngViaIP: true,
      aroundRadius: defaultSearchRadius
    }
});



var mapSearchHits = instantsearch.widgets.hits({
  container: document.querySelector('#hits'),
  hitsPerPage: 100,
  templates: {item:
         `
          <div class="col-xs-12 col-sm-6">
            <div class="card">
              <a class='link-to-product' href='https://got-it-wagon.herokuapp.com/products/{{objectID}}}/'>
                <div class='card-body'>
                  <div class='photo' style='background-image: url({{photo}})'>
                    <div class='card-avatar' style='background-image: url({{owner_photo}})'></div>
                  </div>
                </div>
                <div class="card-footer">
                  <div class="left">
                    <div class="name">
                      {{name}}
                    </div>
                    <div class="distance">
                      14km away
                    </div>
                  </div>
                  <div class="right">
                    <div class="price-per-day price">
                      £{{price_per_day}}<span>/day</span>
                    </div>
                    <div class="review-stars kill-padding">
                        {{average_rating}}
                        <i class="fa fa-star gold-star" aria-hidden="true"></i>
                        <i class="fa fa-star gold-star" aria-hidden="true"></i>
                        <i class="fa fa-star gold-star" aria-hidden="true"></i>
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
  // placeholder: 'Search for products...',
  searchOnEnterKeyPressOnly: false,
  wrapInput: false
});

var customMapWidget = {
  markers: [],
  _mapContainer: document.querySelector('#map'),
  _hitToMarker: function(hit) {

    products.push(hit);
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
    this._map.setOptions({ maxZoom: 15 });
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

// get user position via ip
navigator.geolocation.getCurrentPosition(function(position) {
  userLat = position.coords.latitude;
  userLng = position.coords.longitude;
  listDistancesOfProducts();
  updateDistance();
  setProductCount();
});

// get products distance and push to list of distances
listDistancesOfProducts = () => {
  products.forEach(function(product) {
    distanceInKm.push(getDistance(product));
  });
  updateDistance();
};

getDistance = (product) => {
  productLat = product._geoloc.lat;
  productLng = product._geoloc.lng;
  return (getDistanceFromLatLonInKm(userLat, userLng, productLat, productLng));
}

updateDistance = () => {
var matches = document.querySelectorAll("span.distance");
for (i=0; i<matches.length; i++){

    if (distanceInKm[i] === 0){
      matches[i].innerHTML = "";
    } else {
      matches[i].innerHTML = `${distanceInKm[i]}km away`;
    }
  }
}

//reset lists
resetVars = () => {
  products = [];
  distanceInKm = [];
}

// -----------------------------------------------------------------------------
// --- search box style script ---

var addressSearch = document.getElementById('addressSearch')
var geocoder = new google.maps.Geocoder();
var address;

AddressOverSearch = document.getElementById('address-over-search');
AddressOverSearch.addEventListener('click', function(){
  this.remove();
  focusMethodAddress();
});

DistanceOverSearch = document.getElementById('distance-over-search');
DistanceOverSearch.addEventListener('click', function(){
  this.remove();
  focusMethodDistance();
});

focusMethodAddress = function getFocus() {
  addressSearch.focus();
}

focusMethodDistance = function getFocus() {
  searchDistance.focus();
}

// this is the geocoding for the search from address function
addressSearch.addEventListener('keyup', throttle(function() {
  getGeocodeLatLng();
}));

getGeocodeLatLng = () => {
  searchPrecision = [];
  address = addressSearch.value;
  geocoder.geocode( { 'address': address}, function(results, status) {
  if (status == google.maps.GeocoderStatus.OK) {
      var latitude = results[0].geometry.location.lat();
      var longitude = results[0].geometry.location.lng();
      searchPrecision = {lat: latitude, lng: longitude};

    }
  });
};

// this slows down functions so that they catch up and don't call on keyups too quickly.
function throttle(f, delay){
    var timer = null;

    return function(){
        var context = this, args = arguments;
        clearTimeout(timer);
        timer = window.setTimeout(function(){
            f.apply(context, args);
        },
        delay || 500);
    };
}


// sets default value for search box
var searchBoxElement = document.querySelector('#searchBox > input');
searchBoxElement.value = '';
index.search({query: searchBoxElement.value}, function searchDone(err, content) {
  console.log(content);
});

searchBoxElement.addEventListener('keyup', function() {
  if (products.length === 0){

  } else {

    listDistancesOfProducts();
    updateDistance();
    setProductCount();
    resetVars();
  }
});

