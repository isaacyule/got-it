// var map = require("./map.js");

import { buildSearchParams } from './search_on_address';
import myMap from './map';
import { newMap } from './map';

var distanceInKilometers = require("./distance_calculator.js");
var card = require("./card_constructor.js");

var cardContainer = document.getElementById('hits');
let userLat;
let userLng;
let productLat;
let productLng;
var userPos;

let markers = [];
let products = [];
let distanceInKm = [];
let defaultSearchRadius = 5000;
let searchResultsCount = 'There are currently no';

var client = algoliasearch("3QRXVE4VDT", "0448f9b83bca12989799aaf181b86677");
var index = client.initIndex('Product');
var searchBoxElement = document.getElementById('searchBoxElement');
var addressSearch = document.getElementById('addressSearch')

// gets search params from URL
function getParams(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}

var setProductCount = () => {
  var counter = document.getElementById('counter');
  counter.innerHTML = `${searchResultsCount} search results in your area...`;
}

// this slows down functions so that they catch up and don't call on keyups too quickly.
function throttle(f, delay){
    var timer = null;
    return function(){
        var context = this, args = arguments;
        clearTimeout(timer);
        timer = window.setTimeout(function(){
            f.apply(context, args);
        },
        delay || 300);
    };
}

var performSearch = (options, params) => {
  //remove markers from map -----???
  var cardToMarker = {}
  myMap.deleteMarkers(markers)
  markers = [];
  // -------------------------------
  cardContainer.innerHTML = '';
  if (!options) options = {};
  if (params) searchBoxElement.value = params;
  if (!params) params = searchBoxElement.value;
  options['query'] = params;

  // handle map center

  index.search(options, function searchDone(err, content) {
    if (err) {
      console.error(err);
      return;
    }
    // set counter at top of page to the total number of search results
    searchResultsCount = content.hits.length;
    setProductCount();
    content.hits.forEach(function(hit) {
      // create a marker and push to markers array
      markers.push(myMap.newMarker(hit._geoloc, map, hit.name, hit.objectID));

      // for each result create a card
      cardContainer.insertAdjacentHTML('afterbegin', card.constructCard(hit));
      // push result to the array of product results
      products.push(hit);
    });
    if (content.hits.length === 0){
      cardContainer.innerHTML = `
      <div class="no-results"><h3>We couldn't find any matching products within your search. Maybe you have found a niche ;)</h3></div>`
    }
    if (markers.length > 0){
      myMap.fitToBounds(markers, map);
    } else {
      if ('aroundLatLng' in options){
        var locationLiteral = options['aroundLatLng'].split(', ');
        var lat = parseFloat(locationLiteral[0]);
        var lng = parseFloat(locationLiteral[1]);
        myMap.setCenter({lat: lat, lng: lng}, map);
      } else {
        myMap.setCenter(userPos, map);
      }
    }
    for (var i=0; i<markers.length; i++) {
      var marker = markers[i];
      var id = markers[i].js_id.split('_');
      var cardId = 'card_' + id[1];
      console.log(marker);
      console.log(cardId);
      cardToMarker[cardId] = marker;
      var cardHover = document.getElementById(cardId);
      cardHover.addEventListener('mouseover', function(){
        cardToMarker[this.id].setIcon('https://www.google.com/mapfiles/marker_green.png');
      })
      cardHover.addEventListener('mouseout', function() {
          cardToMarker[this.id].setIcon();
      });
    };
  })
};

searchBoxElement.addEventListener('keyup', throttle(function() {
  buildSearchParams(performSearch);
}, 300));

//----------------------------------------END ALGOLIA---------------------------

const map = newMap(51.5074, 0.1278);

addressSearch.addEventListener('keyup', throttle(function() {
  buildSearchParams(performSearch);
}));

// get user position via ip
navigator.geolocation.getCurrentPosition(function(position) {
  userLat = position.coords.latitude;
  userLng = position.coords.longitude;
  userPos = {lat: userLat,  lng: userLng};
  listDistancesOfProducts();
  setProductCount();
  resetVars();
  // myMap.setCenter(userPos, map);
});

// get products distance and push to list of distances
var listDistancesOfProducts = () => {
  products.forEach(function(product) {
    distanceInKm.push(getDistance(product));
  });
  updateDistance();
};

var getDistance = (product) => {
  productLat = product._geoloc.lat;
  productLng = product._geoloc.lng;
  return (distanceInKilometers.distanceCalculator(userLat, userLng, productLat, productLng));
}

var updateDistance = () => {
var matches = document.querySelectorAll(".distance");
for (var i=0; i<matches.length; i++){

    if (distanceInKm[i] === 0){
      matches[i].innerHTML = "";
    } else {
      matches[i].innerHTML = `${distanceInKm[i]}km away`;
    }
  }
}

//reset lists
var resetVars = () => {
  products = [];
  distanceInKm = [];
}


// --- search box style script ---
var geocoder = new google.maps.Geocoder();
var address;

var AddressOverSearch = document.getElementById('address-over-search');
AddressOverSearch.addEventListener('click', function(){
  this.remove();
  focusMethodAddress();
});

var DistanceOverSearch = document.getElementById('distance-over-search');
DistanceOverSearch.addEventListener('click', function(){
  this.remove();
  focusMethodDistance();
});

var focusMethodAddress = function getFocus() {
  addressSearch.focus();
}

var focusMethodDistance = function getFocus() {
  searchDistance.focus();
}

new google.maps.places.Autocomplete(addressSearch);

const searchRadius = document.getElementById('searchDistance')
  searchRadius.addEventListener('keyup', throttle(function(){
    buildSearchParams(performSearch);
  }));








performSearch({aroundLatLngViaIP: true, aroundRadius: 5000}, getParams('search'))
