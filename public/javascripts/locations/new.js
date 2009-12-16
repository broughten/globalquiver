var geocoder = null;

/* Definition of the class to hold the address information */
function Address(){
	this.street = "";
	this.city = "";
	this.state = "";
	this.zipCode = "";
	this.country = "";
	this.accuracy = -1;
	this.latLng = null;
	this.addressString = "";
}
Address.prototype.isValid = function() {
	return this.accuracy > 0;
}

function processGeoCodeResponse(response, callback) {
    if (!response || response.Status.code != 200) {
      alert(JSON.stringify(response));
      createErrorMsg();
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
    callback(ourAddress);
  }

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


