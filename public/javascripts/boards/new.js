var optional_fields_visible;  // keeps track of state of the optional fields
/* Do all of the things that you need to do 
	once the page is ready to go. */
$(document).ready(function(){
   	var new_id = $("#board_location_selector").val();
	if(new_id > 0){
		set_board_location_id(new_id);
	}
	optional_fields_visible = displayOptionalBoardFields(false);
	$('#hide_show_optional_fields').click(function(){
		optional_fields_visible = displayOptionalBoardFields(!optional_fields_visible);
		});
 });


function set_board_location_id(new_id){
	$("#board_location_id").val(new_id);
}

// returns the state of the optional fields
function displayOptionalBoardFields(show){
	if (show){
		$('#optional_fields').show();
		$('#visibility_indicator').text("Hide");
	}else{
		$('#optional_fields').hide();
		$('#visibility_indicator').text("Show");
	}
	return show;
}

$(function(){
  // find all the input elements with title attributes
  $('input[title!=""]').hint();
});
