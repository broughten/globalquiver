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
        addFormField(date, event.currentTarget, status)
      }
    );
  });



function unavailableDates($td, thisDate, month, year)
{
  checkDate = thisDate.asString('yyyy-mm-dd');
  if (reservedDates != null) {
    for (i = 0; i < reservedDates.length; i++) {
      if (checkDate == reservedDates[i].unavailable_date.date) {
        $td.addClass('disabled reserved');
      }
    }
  }
  if (blackOutDates != null) {
    for (i = 0; i < blackOutDates.length; i++) {
      if (checkDate == blackOutDates[i].unavailable_date.date) {
        // the disabled class prevents the user from being able to select the element.
	$td.addClass('selected');
      }
    }
  }
}



function addFormField(date, td, status) {
  if (status) {
    //A date has been selected in the calendar
    if (dateIsAlredyUnavailable(date.asString('yyyy-mm-dd'))) {
      //and if the date was just chosen during this session and later
      //unselected, this will remove
      //the hidden field from the form.
      tagToRemove = $('input[value="' + getUnavailableDateId(date.asString('yyyy-mm-dd')) + '"]');
      if (tagToRemove) {
        otherTagToRemove = tagToRemove.next();
        otherTagToRemove.remove();
        tagToRemove.remove();
      }
     
    } else {
      //this adds a hidden input field containing the selected
      //date to the form.
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='" + board_type + "[black_out_dates_attributes][][id]");
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='" + board_type + "[black_out_dates_attributes][][date]' " +
      "value='" + date.asString() + "'>");
    }
  } else {
    //A date has been unselected in the calendar
    if (dateIsAlredyUnavailable(date.asString('yyyy-mm-dd'))) {
      //this creates an hidden input with the date marked for removal
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='" + board_type + "[black_out_dates_attributes][][id]' " +
      "value='" + getUnavailableDateId(date.asString('yyyy-mm-dd')) +"'>");
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='" + board_type + "[black_out_dates_attributes][][_delete]' " +
      "value='1'>");
    } else {
      //and if the date was just chosen during this session and later
      //unselected, this will remove
      //the hidden field from the form.
      tagToRemove = $('input[value="' + date.asString() + '"]');
      otherTagToRemove = tagToRemove.prev();
      otherTagToRemove.remove();
      tagToRemove.remove();
    }
  }
 }

 function getUnavailableDateId(unavailableDate) {
   if (blackOutDates != null) {
     for (var i = 0; i < blackOutDates.length; i++) {
       if (blackOutDates[i].unavailable_date.date == unavailableDate) {
         return blackOutDates[i].unavailable_date.id;
       }
     }
   }
   return null;
 }

 function dateIsAlredyUnavailable(possiblyAlreadyUnavailableDate) {
   if (blackOutDates != null) {
     for (var i = 0; i < blackOutDates.length; i++) {
       if (blackOutDates[i].unavailable_date.date == possiblyAlreadyUnavailableDate) {
         return true;
       }
     }
   }
   return false;

 }