$(function()
  {
    $('#multimonth').datePickerMultiMonth(
      {
        createButton:false,
	displayClose:false,
	closeOnSelect:false,
	selectMultiple:true,
        numMonths: 4,
        inline: true,
        renderCallback: unavailableDates
      }
    ).bind(
      'click',
      function()
      {
        $(this).dpDisplay();
        this.blur();
        return false;
      }

    ).bind(
      'dpMonthChanged',
      function(event, displayedMonth, displayedYear)
      {
        // uncomment if you have firebug and want to confirm this works as expected...
        //console.log('dpMonthChanged', arguments);
      }
    ).bind(
      'dateSelected',
      function(event, date, $td, status)
      {
        // uncomment if you have firebug and want to confirm this works as expected...
        //console.log('dateSelected', arguments);
        addFormField(date, status)
      }
    );
  });



function unavailableDates($td, thisDate, month, year)
{

  for (i = 0; i < blackOutDates.length; i++) {
    if (thisDate.asString() == blackOutDates[i]) {
    // the disabled class prevents the user from being able to select the element.
    // the disallowed-day class provides a hook for different CSS styling of cells which are disabled
    // by this rule vs cells which are disabled because e.g. they fall outside the startDate - endDate range.
    $td.addClass('disabled disallowed-day');
    }
  }

    for (i = 0; i < reservedDates.length; i++) {
    if (thisDate.asString() == reservedDates[i]) {
    // the disabled class prevents the user from being able to select the element.
    // the disallowed-day class provides a hook for different CSS styling of cells which are disabled
    // by this rule vs cells which are disabled because e.g. they fall outside the startDate - endDate range.
    $td.addClass('disabled disallowed-day');
    }
  }
  
 }



function addFormField(date, status) {
  //this adds a hidden input field containing the selected
  //date to the form.
  if (status) {
    $("#multimonth").append(
      "<input type='hidden' " +
      "name='board[unavailable_dates_attributes][][date]' " +
      "value='" + date.asString() + "'>");
  } else {
    //and if the date is ever unselected, this will remove
    //the hidden field from the form.
    $('input[value="' + date.asString() + '"]').remove();
  }
 }