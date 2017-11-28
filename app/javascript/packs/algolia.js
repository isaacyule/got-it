// var map = require("./map.js");

import { buildSearchParams } from './search_on_address';

var distanceInKilometers = require("./distance_calculator.js");
var card = require("./card_constructor.js");
var googleMap = require("./map.js");

var cardContainer = document.getElementById('hits');
let userLat;
let userLng;
let productLat;
let productLng;

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
        delay || 500);
    };
}

var performSearch = (options, params) => {
  cardContainer.innerHTML = '';
  if (!options) options = {};
  if (!params) params = searchBoxElement.value;
  options['query'] = params;

  index.search(options, function searchDone(err, content) {
    if (err) {
      console.error(err);
      return;
    }
    // set counter at top of page to the total number of search results
    searchResultsCount = content.hits.length;
    setProductCount();
    content.hits.forEach(function(hit) {
      // for each result create a card
      cardContainer.insertAdjacentHTML('afterbegin', card.constructCard(hit));
      // push result to the array of product results
      products.push(hit);
    })
    products.forEach(function(product){
      var marker = new google.maps.Marker({
        position: product._geoloc,
        map: map
      });
    })
  })
};

searchBoxElement.addEventListener('keyup', throttle(function() {
  buildSearchParams(performSearch);
}, 500));

//----------------------------------------END ALGOLIA---------------------------

addressSearch.addEventListener('keyup', throttle(function() {
  buildSearchParams(performSearch);
}));

// get user position via ip
navigator.geolocation.getCurrentPosition(function(position) {
  userLat = position.coords.latitude;
  userLng = position.coords.longitude;
  var userPos = {lat: userLat,  lng: userLng};
  listDistancesOfProducts();
  updateDistance();
  setProductCount();
  resetVars();
  map.setCenter(userPos);
});

// get products distance and push to list of distances
var listDistancesOfProducts = () => {
  products.forEach(function(product) {
    distanceInKm.push(getDistance(product));
  });
  // updateDistance();
};

var getDistance = (product) => {
  productLat = product._geoloc.lat;
  productLng = product._geoloc.lng;
  return (distanceInKilometers.distanceCalculator(userLat, userLng, productLat, productLng));
}

var updateDistance = () => {
  var matches = document.querySelectorAll("span.distance");
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



// maps - maps - maps - maps - maps - maps - maps - maps - maps - maps - maps - \\
var mapStyle = require("./map_styles.js");
var map;

function initMap(lat, lng) {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: lat, lng: lng},
    styles: mapStyle.styleMap(),
    zoom: 12
  });
}

// define search radius from specified or user location
const searchRadius = document.getElementById('searchDistance')
searchRadius.addEventListener('keyup', throttle(function(){
  if (searchRadius.value == 0){
    defaultSearchRadius = 5000;
  } else {
    defaultSearchRadius = searchRadius.value*1000;
  }
  buildSearchParams(performSearch);
}));

initMap(51.5074, 0.1278);
performSearch({}, getParams('search'));
