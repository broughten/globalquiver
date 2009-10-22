var geocoder = null;

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

/* Code to set initial states of the page once the DOM is ready to go. */
Event.observe(document, 'dom:loaded',function() {
	// set up the initial state of the form from the selected location.
	var new_id = $("board_location_selector").value;
	if(new_id > 0){
		set_board_location_id(new_id);
	}else{
		set_board_location_id(-1);
	}
});

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
    $("location_street").value = currentAddress.street;
    $("location_locality").value = currentAddress.city;
    $("location_region").value = currentAddress.state;
    $("location_postal_code").value = currentAddress.zipCode;
    $("location_country").value = currentAddress.country;
    
    $("street").innerHTML = currentAddress.street;
    $("locality").innerHTML = currentAddress.city;
    $("region").innerHTML = currentAddress.state;
    $("postal_code").innerHTML = currentAddress.zipCode;
    $("country").innerHTML = currentAddress.country;
    $("accuracy").innerHTML = currentAddress.accuracy;
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
	$("board_location_id").value = new_id;
}

function enableNewLocationEntry(){
	Effect.Appear('locationFields', {afterFinish:function(){map.checkResize();}});
	Effect.Fade('locationPicker');
	if(haveExistingLocation()){
		showBoardDetailsFields();
	}else{
		hideBoardDetailsFields();
	}
	
	set_board_location_id(-1); 
}

function cancelNewLocationEntry(){
	Effect.Fade('locationFields');
	Effect.Appear('locationPicker');
	showBoardDetailsFields();
	set_board_location_id($("board_location_selector").value);
}

function showBoardDetailsFields(){
	Effect.Appear('boardDetails', 'appear');
}

function hideBoardDetailsFields(){
	Effect.Fade('boardDetails', 'appear');
}

function haveExistingLocation(){
	return $("location_street").value != "";
}








