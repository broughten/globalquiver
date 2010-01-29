var DEFAULT_ZOOM = 13;
Address.MIN_ACCURACY = 6;
/* This should stay in the window.onload event.  Not sure why
	but don't change it! */
window.onload = addCodeToFunction(window.onload,function() {
	GEvent.addListener(map, "click", getAddress);
	geocoder = new GClientGeocoder();
});

/* Do all of the things that you need to do 
	once the page is ready to go. */
$(document).ready(function(){
   	toggleLocationSubmitButton(false);
 });


function showAddress(addressString) {
  if (geocoder) {
    geocoder.getLocations(addressString, boardProcessGeoCodeResponse);
  }
	else{
		alert("Unable to show address.");
	}
}

function getAddress(overlay, latlng) {
	if (geocoder && latlng != null) {
		geocoder.getLocations(latlng, boardProcessGeoCodeResponse);
	}
}

function boardProcessGeoCodeResponse(response) {
  processGeoCodeResponse(response, boardGeocodeActions);
}

function boardGeocodeActions(ourAddress) {
  if(ourAddress && ourAddress.isValid){
    if(ourAddress.accuracy > Address.MIN_ACCURACY){
      addAddressToMap(ourAddress);
      populateFormFields(ourAddress);
      toggleLocationSubmitButton(true);
    }else{
      addAddressToMap(ourAddress);
      toggleLocationSubmitButton(false);
      alert ("Address isn't exact enough.  Please try again.");
    }
  }else{
    alert ("We couldn't find that address.  Please try again.");
  }
}

function addAddressToMap(currentAddress) {
    map.clearOverlays();
    var marker = new GMarker(currentAddress.latLng);
    map.addOverlay(marker);
    marker.openInfoWindowHtml('<b>Address: </b>' + currentAddress.addressString + '<br>');
    map.setCenter(currentAddress.latLng,DEFAULT_ZOOM);
}

function populateFormFields(currentAddress){
    $("#board_location_street").val(currentAddress.street);
    $("#board_location_locality").val(currentAddress.city);
    $("#board_location_region").val(currentAddress.state);
    $("#board_location_postal_code").val(currentAddress.zipCode);
    $("#board_location_country").val(currentAddress.country);
    $("#board_location_accuracy").val(currentAddress.accuracy);
}

function toggleLocationSubmitButton(show){
	if(show){
		$("#board_location_submit").show();
	}else{
		$("#board_location_submit").hide();
	}
}

