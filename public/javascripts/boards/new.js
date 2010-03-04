var optional_fields_visible;  // keeps track of state of the optional fields
/* Do all of the things that you need to do once the page is ready to go. */
$(document).ready(function(){
  var new_id = $("#board_location_selector").val();
  if(new_id > 0){
    set_board_location_id(new_id);
  }
  $('#hide_show_optional_fields').click(function(){
    toggleOptionalBoardFields();
  });

  $('input',document.new_board_form).bind("change", function() {
    setConfirmUnload(true); // Prevent accidental navigation away
  });

  $("form").submit(function() {
    setConfirmUnload(false);
    return true;
  });



  $("#specific-board").click(function() {
    show_specific_board();
  });

  $("#generic-board").click(function() {
    show_generic_board();
  });

	$("#board_for_rent").click(function() {
    toggleRentPurchaseFields();
  });

	$("#board_for_purchase").click(function() {
    toggleRentPurchaseFields();
  });

  var sb_radio_button =  $("#specific-board");
  if (sb_radio_button.attr("checked") != "undefined" && sb_radio_button.attr("checked") == "checked") {
    show_specific_board();
  }
  var gb_radio_button =  $("#generic-board");
  if (gb_radio_button.attr("checked") != "undefined" && gb_radio_button.attr("checked") == "checked") {
    show_generic_board();
  }

  
});

function show_specific_board() {
  $("#board_lower_length_feet").attr("disabled","disabled");
  $("#board_lower_length_inches").attr("disabled","disabled");
  $("#board_upper_length_feet").attr("disabled","disabled");
  $("#board_upper_length_inches").attr("disabled","disabled");
  $("#upper-and-lower-lengths").hide();

  $("#board_maker").removeAttr("disabled");
  $("#board_model").removeAttr("disabled");
  $("#board_length_feet").removeAttr("disabled");
  $("#board_length_inches").removeAttr("disabled");
  $("#maker-model-length").show();

  $("#board_width_inches").removeAttr("disabled");
  $("#board_width_fraction").removeAttr("disabled");
  $("#board_thickness_inches").removeAttr("disabled");
  $("#board_thickness_fraction").removeAttr("disabled");
  $("#width-thickness-construction").show();

  $("#fee-type-question").show();
  $("#board_daily_fee").attr("disabled","disabled");
  $("#board_purchase_price").removeAttr("disabled");
  $("#board_buy_back_price").removeAttr("disabled");

}

function show_generic_board() {
  $("#board_lower_length_feet").removeAttr("disabled");
  $("#board_lower_length_inches").removeAttr("disabled");
  $("#board_upper_length_feet").removeAttr("disabled");
  $("#board_upper_length_inches").removeAttr("disabled");
  $("#upper-and-lower-lengths").show();

  $("#board_maker").attr("disabled","disabled");
  $("#board_model").attr("disabled","disabled");
  $("#board_length_feet").attr("disabled","disabled");
  $("#board_length_inches").attr("disabled","disabled");
  $("#maker-model-length").hide();

  $("#board_width_inches").attr("disabled","disabled");
  $("#board_width_fraction").attr("disabled","disabled");
  $("#board_thickness_inches").attr("disabled","disabled");
  $("#board_thickness_fraction").attr("disabled","disabled");
  $("#width-thickness-construction").hide();

  $('input[id="board_for_rent"]').attr('checked', true);
  $("#fee-type-question").hide();
  $("#purchase_info").hide();
  $("#rental_info").show();
  $("#board_daily_fee").removeAttr("disabled");
  $("#board_purchase_price").attr("disabled","disabled");
  $("#board_buy_back_price").attr("disabled","disabled");
}

function set_board_location_id(new_id){
  $("#board_location_id").val(new_id);
}

function toggleOptionalBoardFields(){
	$('#optional_fields').toggle(600,setVisibilityIndicator);
}

function setVisibilityIndicator(){
  if ($('#optional_fields').is(':visible')){
    $('#visibility_indicator').text("Hide");
  }else{
    $('#visibility_indicator').text("Show");
  }
}

function toggleRentPurchaseFields(){
	if ($('#board_for_rent').is(':checked')){
		// board is for rent
   	$('#purchase_info').hide();
		$('#rental_info').show();
  }else { // board is for sale
    $('#purchase_info').show();
		$('#rental_info').hide();
  }
	
	
}


////stuff below is about warning a user when navigating awawy.
function setConfirmUnload(on) {
  window.onbeforeunload = (on) ? unloadMessage : null;
}

function unloadMessage() {
  return 'You have entered new data on this page.  If you navigate away from this page without first saving your data, the changes will be lost.';
}
