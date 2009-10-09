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
