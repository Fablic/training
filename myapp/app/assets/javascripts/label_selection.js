// app/assets/javascripts/label_selection.js

$(document).ready(function() {
    $('.label-button').click(function(event) {
      event.preventDefault(); // Prevent the default behavior (form submission)
      $(this).toggleClass('selected-label');
    });
  });
