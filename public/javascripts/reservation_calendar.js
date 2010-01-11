$(document).ready(function() {
  $(".reservation").live("mouseover", function() {
    $(this).css("background-color", "#2EAC6A");
  });
  $(".reservation").live("mouseout", function() {
    $(this).css("background-color", "#9aa4ad");
  });
})
