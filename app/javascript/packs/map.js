var mapStyle = require("./map_styles.js");

export const newMap = (lat, lng) =>{
  let map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: lat, lng: lng},
    styles: mapStyle.styleMap(),
    zoom: 13,
    maxZoom: 15,
    minZoom: 10
  });
  return map;
}

const myMap = {
  setCenter: function(latLng, map){
    map.setCenter(latLng);
  },
  setZoom: function(zoom, map) {
    map.setZoom(zoom);
  },
  newMarker: function(latLng, map, title){
    var marker = new google.maps.Marker({
      position: latLng,
      map: map,
      title: title
    });
    return marker;
  },
  deleteMarkers: function(markers, map){
    for (var i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
    }
  },
  fitToBounds: function(markers, map){
    console.log('executing fitToBounds');
    var bounds = new google.maps.LatLngBounds();
    for (var i = 0; i < markers.length; i++) {
      console.log('hello', markers[i].getPosition());
      bounds.extend(markers[i].getPosition());
    }
  map.fitBounds(bounds);
  }
}




export default myMap;

