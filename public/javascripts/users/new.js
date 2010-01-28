/* Do all of the things that you need to do 
	once the page is ready to go. */
$(document).ready(function(){
   	initialize();
 });

function initialize(){
	if ($('#is_shop')) {
            // set up the initial state
            toggleNames($('#is_shop').is(':checked'));
            // register the event handlers.
            $('#is_shop').click(function(){toggleNames($(this).is(':checked'))});
	}
}

function toggleNames(isShop){
    if(isShop){
        hideSurferSpecificFields();
        showShopSpecificFields();
    }else{
        showSurferSpecificFields();
        hideShopSpecificFields();
    }
}

function hideShopSpecificFields(){
  $('#user_name').parent().hide();
  $('#shop-text').hide();
}

function showShopSpecificFields(){
  $('#user_name').parent().show();
  $('#shop-text').show();

}

function hideSurferSpecificFields(){
  $('#user_first_name').parent().hide();
  $('#user_last_name').parent().hide();
}

function showSurferSpecificFields(){
  $('#user_first_name').parent().show();
  $('#user_last_name').parent().show();
}