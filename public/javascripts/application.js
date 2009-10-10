// TODOS
// make each form hide when anywhere else is clicked
// make name fields clear on focus, repopulate on blur

function showLoginForm(e)
{
  e.stop();
  $('header_signup_form').hide();
  $('signup_link').removeClassName("active");
  $('login_link').addClassName("active");
  $('header_login_form').show();
}

function showSignupForm(e)
{
  e.stop();
  $('header_login_form').hide();
  $('login_link').removeClassName("active");
  $('signup_link').addClassName("active");
  $('header_signup_form').show();
}


function closeModalForms()
{
  if ($('header_signup_form') && $('signup_link')) {
    $('header_signup_form').hide();
    $('header_login_form').hide();
    $('signup_link').removeClassName("active");
    $('login_link').removeClassName("active");
  }
}

function cancelClick(e)
{
  e.stopPropagation();
}


Event.observe(document, 'dom:loaded',function() {

  if ($('header_signup_form')) {
    $('header_signup_form').observe('click', cancelClick);
  }

  if ($('header_login_form')) {
    $('header_login_form').observe('click', cancelClick);
  }

  if ($('login_link'))   $('login_link').down('a').observe('click', showLoginForm);
  if ($('signup_link'))  $('signup_link').down('a').observe('click', showSignupForm);

  Event.observe(document, 'click', closeModalForms);

  if ($('is_shop')) {
    // set up the initial state
    toggleNames($('is_shop').checked);
    // register the event handlers.
    $('is_shop').observe('click', function(){toggleNames(this.checked)});
  }

});



function writeFlash(name, w, h, t)
{
  document.write('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="'+w+'" height="'+h+'">');
  document.write('<param name="movie" value="'+name+'">');
  document.write('<param name="quality" value="best">');
  document.write('<param name="wmode" value="'+t+'">');

  document.write('<embed src="'+name+'" quality="best" wmode="'+t+'" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="'+w+'" height="'+h+'"></embed>');
  document.write('</object>');
}


function simple_format(text) 
{
  newString = "<p>";
  text = text.gsub(/\n\n+/, "</p>\n\n<p>");
  text = text.gsub(/([^\n]\n)(?=[^\n])/, '<br />');
  newString += text + "</p>";
  return newString;
}

function toggleNames(checked){
    if(checked){
        // you are a shop so show the name field/label
        // and hide the first name/last name field/label
        $('user_first_name').up().hide();
        $('user_last_name').up().hide();
        $('user_name').up().show();
    }else{
        // you are a surfer so hide name field/label
        // and show first name/last name field/label
        $('user_first_name').up().show();
        $('user_last_name').up().show();
        $('user_name').up().hide();
    }
}
