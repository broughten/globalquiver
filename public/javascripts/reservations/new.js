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
        addReservationDate(date, event.currentTarget, status);
      }
    );
  });

	function unavailableDates($td, thisDate, month, year)
	{
		// block out all of the dates this board is unavailable
	  checkDate = thisDate.asString('yyyy-mm-dd');
	  if (reservedDates != null) {
	    for (i = 0; i < reservedDates.length; i++) {
	      if (checkDate == reservedDates[i].unavailable_date.date) {
	        $td.addClass('disabled blackout');
	      }
	    }
	  }
	  if (blackOutDates != null) {
	    for (i = 0; i < blackOutDates.length; i++) {
	      if (checkDate == blackOutDates[i].unavailable_date.date) {
					$td.addClass('disabled blackout');
	      }
	    }
	  }
	}
function addReservationDate(date, td, status) {
	if (status) {
		//A date has been selected in the calendar
		//this adds a hidden input field containing the selected
    //date to the form.
    $("#dates").append(
    "<input type='hidden' " +
    "name='reservation[reserved_dates_attributes][][id]");
    $("#dates").append(
    "<input type='hidden' " +
    "name='reservation[reserved_dates_attributes][][date]' " +
    "value='" + date.asString() + "'>");
		//add the li
		$("#dates ul").append("<li id='" + date.asString("yyyy-mm-dd") + "'>" + date.asString() + "</li>");
	} else {
		//A date has been unselected in the calendar
		//this will remove
    //the hidden field from the form.
    hiddenInputToRemove = $('input[value="' + date.asString() + '"]');
    otherInputToRemove = hiddenInputToRemove.prev();
    otherInputToRemove.remove();
    hiddenInputToRemove.remove();
		//remove the li
		$('li[id="' + date.asString("yyyy-mm-dd") + '"]').remove();
	}
}

