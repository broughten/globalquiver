
function set_location_id(new_id){
  $("#location-id").val(new_id);
}

/* This should stay in the window.onload event.  Not sure why
	but don't change it! */
window.onload = addCodeToFunction(window.onload,function() {
  geocoder = new GClientGeocoder();
});

function checkAddress(addressString) {
  if (geocoder) {
    geocoder.getLocations(addressString, userProcessGeoCodeResponse);
  }
  else {
    createErrorMsg();
  }
  return false;
}

function userProcessGeoCodeResponse(response) {
  processGeoCodeResponse(response, userGeoCodeActions)
}

function createErrorMsg() {
  $("#address-error").css("display", "block");
}


function userGeoCodeActions(ourAddress) {
  if(ourAddress && ourAddress.isValid){
    populateUserFormFields(ourAddress);
    submitForm();
  }else{
    createErrorMsg();
  }
}

function populateUserFormFields(ourAddress) {
  $(".street").val(ourAddress.street);
  $(".city").val(ourAddress.city);
  $(".state").val(ourAddress.state);
  $(".zip").val(ourAddress.zipCode);
  $(".country").attr('disabled', true);
  $("input#surfer_user_location_attributes_country").val(ourAddress.country);
  $("input#shop_user_location_attributes_country").val(ourAddress.country);

}

function submitForm() {
  $("#location-form").submit();
}