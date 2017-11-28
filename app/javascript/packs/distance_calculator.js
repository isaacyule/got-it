module.exports = {
  distanceCalculator: function(lat1,lon1,lat2,lon2) {
    //calculates distance in km between locations
    function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
      console.log(lat1,lon1, lat2, lon2);
      if (lat2 === 0 || lon2 === 0 || lat1 === 0 || lon1 === 0){
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
  console.log('distance = ', getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2));
  return getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2);
  }
}
