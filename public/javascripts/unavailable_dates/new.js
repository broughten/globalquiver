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
  checkDate = thisDate.asString('yyyy-mm-dd');
  if (blackOutDates != null)
  {
    for (i = 0; i < blackOutDates.length; i++) {
      if (checkDate == blackOutDates[i].unavailable_date.date) {
        // the disabled class prevents the user from being able to select the element.
        $td.addClass('disabled blackout');
      }
    }
  }
  if (reservedDates != null) {
    for (i = 0; i < reservedDates.length; i++) {
      if (checkDate == reservedDates[i].unavailable_date.date) {
        $td.addClass('selected');
      }
    }
  }
  if (takenDates != null) {
      for (i = 0; i < takenDates.length; i++) {
      if (checkDate == takenDates[i].unavailable_date.date) {
        $td.addClass('disabled reserved');
      }
    }
  }

  
 }



function addFormField(date, status) {
  if (status) {
    if ((reservedDates !=null) && ($.inArray(date.asString(), reservedDates) > -1)) {
      //do nothing... it is already reserved, and the user is just adding it back in
    } else {
      //this adds a hidden input field containing the selected
      //date to the form.
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='board[unavailable_dates_attributes][][id]");
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='board[unavailable_dates_attributes][][date]' " +
      "value='" + date.asString() + "'>");

    }
  } else {
    if ((reservedDates != null) && dateIsAlredyReserved(date.asString('yyyy-mm-dd'))) {
      //this creates an hidden input with the date marked for removal

      $("#multimonth").append(
      "<input type='hidden' " +
      "name='board[unavailable_dates_attributes][][id]' " +
      "value='" + getReservedDateId(date.asString('yyyy-mm-dd')) +"'>");
      $("#multimonth").append(
      "<input type='hidden' " +
      "name='board[unavailable_dates_attributes][][_delete]' " +
      "value='1'>");
    } else {
      //and if the date was just chosen during this session and later
      //unselected, this will remove
      //the hidden field from the form.
      $('input[value="' + date.asString() + '"]').remove();
    }
  }
 }

 function getReservedDateId(reservedDate) {
   for (var i = 0; i < reservedDates.length; i++) {
     if (reservedDates[i].unavailable_date.date == reservedDate) {
       return reservedDates[i].unavailable_date.id;
     }
   }
   return null;
 }

 function dateIsAlredyReserved(possiblyAlreadyReservedDate) {
   for (var i = 0; i < reservedDates.length; i++) {
     if (reservedDates[i].unavailable_date.date == possiblyAlreadyReservedDate) {
       return true;
     }
   }
   return false;

 }