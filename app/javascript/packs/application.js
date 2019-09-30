// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")


$(document).ready(function() {
    console.log("DOC READY")
    $("#btn").click(function() {
        $('#bikeForm').show()
    })
    $(".bikeDeliveryForm input").click(function() {
       sendAddress();
    })
})



 var sendAddress = function() {
  $.ajax({
      type: "POST",
      url: "/deliveryValid",
      data: {postcode: ""},
      success: function(returnedData) {console.log(returnedData)},
      dataType: 'json'
  });
}

$( "#bikeDeliveryForm" ).submit(function( event ) {

  // Stop form from submitting normally
  event.preventDefault();

  // Get some values from elements on the page:
  var $form = $( this ),
    term = $form.find( "input[name='address']" ).val(),
    url = $form.attr( "action" );

  // Send the data using post
  var posting = $.post( url, { address: term } );

  // Put the results in a div
  posting.done(function( data ) {
    var content = $( data ).find( "#content" );
    $( "#result" ).empty().append( content );
  });
});



// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
