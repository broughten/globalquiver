$(function()
  {
    $('#multimonth').datePickerMultiMonth(
      {
        createButton:false,
	displayClose:true,
	closeOnSelect:false,
	selectMultiple:true,
        numMonths: 4,
        inline: true
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
        console.log('dpMonthChanged', arguments);
      }
    ).bind(
      'dateSelected',
      function(event, date, $td, status)
      {
        // uncomment if you have firebug and want to confirm this works as expected...
        console.log('dateSelected', arguments);
        addFormField(date, status)
      }
    );

    $('#getSelected').bind(
      'click',
      function(e)
      {
        alert($('#multimonth').dpmmGetSelected());
        return false;
      }
    );
  });


function addFormField(date, status) {
  $("#multimonth").append(
  "<input type='hidden' id='board[black_out_date_attributes]_date' name='board[black_out_date_attributes][][date]' value='" + date.asString() + "'>");
}