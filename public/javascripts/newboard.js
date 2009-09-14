var geocoder;
var street = '';
var city = '';
var state = '';
var zipCode = '';
var country = '';
var point = null;
var address = null;
var accuracy = null;

window.onload = addCodeToFunction(window.onload,function() {
  GEvent.addListener(map, "click", getAddress);
  geocoder = new GClientGeocoder();

});

function showAddress(address) {
  if (geocoder) {
    geocoder.getLocations(
      address,
      parseAddress);
  }
}

function getAddress(overlay, latlng) {
  if (latlng != null) {
    address = latlng;
    geocoder.getLocations(latlng, parseAddress);
  }
}

function parseAddress(response) {
  if (!response || response.Status.code != 200) {
    alert("Sorry, we were unable to geocode that address");
  } else {
    street = '';
    city = '';
    state = '';
    zipCode = '';
    country = '';
    point = null;
    address = null;
    accuracy = null;
    //we do a for-loop here because if the address is generic enough it may bring back more than
    //one result. which in the JSON return would be multiple Placemarks.
    var i;
    var currentAccuracy = -1;
    var newAccuracy;
    for (i = 0; i < response.Placemark.length; i++) {
      place = response.Placemark[i];
      newAccuracy = place.AddressDetails.Accuracy;
      if (newAccuracy > currentAccuracy) {
          currentAccuracy = newAccuracy;
          //some addresses have Locality and Thoroughfare under an admin area
          //while others have them directly under country
          if (place.AddressDetails.Country.Locality != null) {
              if (place.AddressDetails.Country.Locality.Thoroughfare != null) {
                 street = place.AddressDetails.Country.Locality.Thoroughfare.ThoroughfareName;
              }
              city = place.AddressDetails.Country.Locality.LocalityName;
          } else {
              //depending on the given address we may not have Locality and we may not have Thoroughfare
              if (place.AddressDetails.Country.AdministrativeArea.Locality != null) {
                city = place.AddressDetails.Country.AdministrativeArea.Locality.LocalityName;

                //check for Thoroughfare
                if (place.AddressDetails.Country.AdministrativeArea.Locality.Thoroughfare != null) {
                  street = place.AddressDetails.Country.AdministrativeArea.Locality.Thoroughfare.ThoroughfareName;
                }

                //check for Zip
                if (place.AddressDetails.Country.AdministrativeArea.Locality.PostalCode) {
                  zipCode = place.AddressDetails.Country.AdministrativeArea.Locality.PostalCode.PostalCodeNumber;
                }
              }
              state = place.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName;
          }
          country = place.AddressDetails.Country.CountryName;
          xCoord = place.Point.coordinates[0];
          yCoord = place.Point.coordinates[1];
          point = new GLatLng(yCoord, xCoord);
          address = place.address;
          accuracy = currentAccuracy;
      }
    }
    addAddress(response);
  }
}


function addAddress() {
    map.clearOverlays();
    marker = new GMarker(point);
    map.addOverlay(marker);
    marker.openInfoWindowHtml(
    '<b>Address: </b>' + address + '<br>' +
    '<b>Accuracy: </b>' + accuracy + '<br>' +
    'The higher the accuracy the better.<br>' +
    'An accuracy of 1 is bad and 8 good.<br>');

    document.getElementById("location_street").removeAttribute("value");
    document.getElementById("location_locality").removeAttribute("value");
    document.getElementById("location_region").removeAttribute("value");
    document.getElementById("location_postal_code").removeAttribute("value");
    document.getElementById("location_country").removeAttribute("value");
    document.getElementById("location_street").setAttribute("value", street);
    document.getElementById("location_locality").setAttribute("value", city);
    document.getElementById("location_region").setAttribute("value", state);
    document.getElementById("location_postal_code").setAttribute("value", zipCode);
    document.getElementById("location_country").setAttribute("value", country);
    document.getElementById("street").innerHTML = "&nbsp;";
    document.getElementById("locality").innerHTML = "&nbsp;";
    document.getElementById("region").innerHTML = "&nbsp;";
    document.getElementById("postal_code").innerHTML = "&nbsp;";
    document.getElementById("country").innerHTML = "&nbsp;";
    document.getElementById("street").innerHTML = (street!='')?"&nbsp;" + street:'&nbsp;';
    document.getElementById("locality").innerHTML = (city!='')?"&nbsp;" + city:'&nbsp;';
    document.getElementById("region").innerHTML = (state!='')?"&nbsp;" + state:'&nbsp;';
    document.getElementById("postal_code").innerHTML = (zipCode!='')?"&nbsp;" + zipCode:'&nbsp;';
    document.getElementById("country").innerHTML = (country!='')?"&nbsp;" + country:'&nbsp;';

}
function writeObj(obj, message) {
  if (!message) { message = obj; }
  var details = "*****************" + "\n" + message + "\n";
  var fieldContents;
  for (var field in obj) {
    fieldContents = obj[field];
    if (typeof(fieldContents) == "function") {
      fieldContents = "(function)";
    }
    details += "  " + field + ": " + fieldContents + "\n";
  }
  console.log(details);
}





