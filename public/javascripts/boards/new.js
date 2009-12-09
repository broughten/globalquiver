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

  $(':input',document.new_board_form).bind("change", function() {
    setConfirmUnload(true); // Prevent accidental navigation away
  });

  $("form").submit(function() {
    setConfirmUnload(false);
    return true;
  });
  
});


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


////stuff below is about warning a user when navigating awawy.
function setConfirmUnload(on) {
  window.onbeforeunload = (on) ? unloadMessage : null;
}

function unloadMessage() {
  return 'You have entered new data on this page.  If you navigate away from this page without first saving your data, the changes will be lost.';
}
