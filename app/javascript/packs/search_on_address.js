var buildSearchParams = (callback) => {
  var value = {};
  var defaultSearchRadius = 5000;
  var searchParams = { aroundLatLngViaIP: true, aroundRadius: defaultSearchRadius };

  // define search radius from specified or user location
  const searchRadius = document.getElementById('searchDistance')
  if (searchRadius.value > 0){
    searchParams['aroundRadius'] = (searchRadius.value * 1000);
  }



  if (addressSearch.value.length === 0){
    if ('aroundLatLng' in searchParams) {
      delete searchCenter['aroundLatLng']
    }
    var key = 'aroundLatLngViaIP';
    value = true;
    searchParams[key] = value;
    callback(searchParams);

  } else {
    if ('aroundLatLngViaIP' in searchParams) {
      delete searchParams['aroundLatLngViaIP']
    }
    var key = 'aroundLatLng';
    var searchPrecision = [];
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( { 'address': addressSearch.value }, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK && typeof results[0].geometry.bounds != 'undefined') {
        var longitude = ((results[0].geometry.bounds.b.b + results[0].geometry.bounds.b.f) / 2);
        var latitude = ((results[0].geometry.bounds.f.b + results[0].geometry.bounds.f.f) / 2);
        searchPrecision[0] = latitude;
        searchPrecision[1] = longitude;
      } else {
        return;
      }
      searchParams['aroundLatLng'] = searchPrecision.join(', ')
      callback(searchParams);
    });
  }
}

export { buildSearchParams };

