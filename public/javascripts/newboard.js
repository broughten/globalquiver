var geocoder = null;
var map = null;

/* Definition of the class to hold the address information */
function Address(){
	this.street = "";
	this.city = "";
	this.stats = "";
	this.zipCode = "";
	this.country = "";
	this.accuracy = -1;
	this.latLng = null;
	this.addressString = "";
}
Address.prototype.isValid = function() {
	return this.accuracy > 0;
}
Address.MIN_ACCURACY = 7;

/* Do all of the things that you need to do 
	once the page is ready to go. */
$(document).ready(function(){
   	var new_id = $("#board_location_selector").val();
	if(new_id > 0){
		set_board_location_id(new_id);
	}
	
 });

/* This should stay in the window.onload event.  Not sure why
	but don't change it! */
window.onload = addCodeToFunction(window.onload,function() {
	GEvent.addListener(map, "click", getAddress);
	geocoder = new GClientGeocoder();
});


function showAddress(addressString) {
  if (geocoder) {
    geocoder.getLocations(addressString, processGetLocationsResponse);
  }
	else{
		alert("Unable to show address.");
	}
}

function getAddress(overlay, latlng) {
	if (geocoder && latlng != null) {
		geocoder.getLocations(latlng, processGetLocationsResponse);
	}
}

function processGetLocationsResponse(response) {
  if (!response || response.Status.code != 200) {
    alert("Sorry, we were unable to process that address. Please try again.");
  } else {
	var ourAddress = null;
    var currentAccuracy = -1;
    var newPlacemark = null;
	var newAccuracy = -1;
	var numberOfPlacemarks = response.Placemark.length;

    //we do a for-loop here because if the address is generic enough it may bring back more than
    //one result. which in the JSON return would be multiple Placemarks.
	for (var i = 0; i < numberOfPlacemarks; i++) {
		newPlacemark = response.Placemark[i];
		newAccuracy = newPlacemark.AddressDetails.Accuracy;
		if (newAccuracy > currentAccuracy) {
			// we care about this placemark because it is more accurate 
			// than the last one
			ourAddress = getAddressFromPlacemark(newPlacemark);
			currentAccuracy = newAccuracy;
		}
	}
	if(ourAddress && ourAddress.isValid){
		if(ourAddress.accuracy > Address.MIN_ACCURACY){
			addAddressToMap(ourAddress);
			populateFormFields(ourAddress);
			showBoardDetailsFields();
		}else{
            addAddressToMap(ourAddress);
			hideBoardDetailsFields();
			alert ("Address isn't exact enough.  Please try again.");
		}
	}else{
		alert ("We couldn't find that address.  Please try again.");
	}
    
  }
}

function addAddressToMap(currentAddress) {
    map.clearOverlays();
    var marker = new GMarker(currentAddress.latLng);
    map.addOverlay(marker);
    marker.openInfoWindowHtml('<b>Address: </b>' + currentAddress.addressString + '<br>');
    map.setCenter(currentAddress.latLng);
}

function populateFormFields(currentAddress){
    $("#location_street").val(currentAddress.street);
    $("#location_locality").val(currentAddress.city);
    $("#location_region").val(currentAddress.state);
    $("#location_postal_code").val(currentAddress.zipCode);
    $("#location_country").val(currentAddress.country);
    
    $("#street").innerHTML = currentAddress.street;
    $("#locality").innerHTML = currentAddress.city;
    $("#region").innerHTML = currentAddress.state;
    $("#postal_code").innerHTML = currentAddress.zipCode;
    $("#country").innerHTML = currentAddress.country;
    $("#accuracy").innerHTML = currentAddress.accuracy;
}

function getAddressFromPlacemark(ourPlacemark){
	var ourAddress = new Address();
	ourAddress.accuracy = ourPlacemark.AddressDetails.Accuracy;
	//some addresses have Locality and Thoroughfare under an admin area
	//while others have them directly under country
	
	if (ourPlacemark.AddressDetails.Country.Locality != null) {
		if (ourPlacemark.AddressDetails.Country.Locality.Thoroughfare != null) {
 			ourAddress.street = ourPlacemark.AddressDetails.Country.Locality.Thoroughfare.ThoroughfareName;
		}
		ourAddress.city = ourPlacemark.AddressDetails.Country.Locality.LocalityName;
	} else {
		//depending on the given address we may not have Locality and we may not have Thoroughfare
		if (ourPlacemark.AddressDetails.Country.AdministrativeArea.Locality != null) {
			ourAddress.city = ourPlacemark.AddressDetails.Country.AdministrativeArea.Locality.LocalityName;

			//check for Thoroughfare
			if (ourPlacemark.AddressDetails.Country.AdministrativeArea.Locality.Thoroughfare != null) {
				ourAddress.street = ourPlacemark.AddressDetails.Country.AdministrativeArea.Locality.Thoroughfare.ThoroughfareName;
            }

            //check for Zip
            if (ourPlacemark.AddressDetails.Country.AdministrativeArea.Locality.PostalCode) {
				ourAddress.zipCode = ourPlacemark.AddressDetails.Country.AdministrativeArea.Locality.PostalCode.PostalCodeNumber;
			}
		} else {
			//just found another address that has a sub administrative area.
			//what a nightmare to parse this crap
			if (ourPlacemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality != null) {
				ourAddress.city = ourPlacemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.LocalityName;
			}
			//check for Thoroughfare
			if (ourPlacemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.Thoroughfare != null) {
				ourAddress.street = ourPlacemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.Thoroughfare.ThoroughfareName;
			}

			//check for Zip
			if (ourPlacemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode) {
				ourAddress.zipCode = ourPlacemark.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.PostalCode.PostalCodeNumber;
			}

		}
		ourAddress.state = ourPlacemark.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName;
	}
	ourAddress.country = ourPlacemark.AddressDetails.Country.CountryName;
	ourAddress.latLng = new GLatLng(ourPlacemark.Point.coordinates[1], ourPlacemark.Point.coordinates[0]);
	ourAddress.addressString = ourPlacemark.address;
	return ourAddress;
}

function set_board_location_id(new_id){
	$("#board_location_id").val(new_id);
}

function enableNewLocationEntry(){
	$('#locationFields').show()
	map.checkResize();
	$('#locationPicker').hide();
	if(haveExistingLocation()){
		showBoardDetailsFields();
	}else{
		hideBoardDetailsFields();
	}
	set_board_location_id(-1); 
}

function cancelNewLocationEntry(){
	$('#locationFields').hide();
	$('#locationPicker').show();
	showBoardDetailsFields();
	set_board_location_id($("#board_location_selector").val());
}

function showBoardDetailsFields(){
	$('#boardDetails').show();
	$("#board_maker").focus();
}

function hideBoardDetailsFields(){
	$('#boardDetails').hide();
}

function haveExistingLocation(){
	return $("#location_street").val() != "";
}








