// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
//= require datetimepicker

$(document).ready(function() {
    console.log("DOC READY")
    $("#btn").click(function() {
        $('#bikeForm').show()
    })
    $(".bikeDeliverySubmit a").click(function() {
       sendAddress();
    })
})

var pickDateTime = function () {
  console.log("inside pickDateTime")
    $('#bikeForm').hide();
    $("#deliverySlots").show();
}

var invalidArea = function () {
  console.log("inside invalidArea")
    $('#bikeForm').hide();
    $("#invalidArea").show();
}


var displaySlots = function (data) {
    $('#dateTime').append("<p></p>")
}


 var sendAddress = function() {
  console.log($("#address").val())
  $.ajax({
      type: "POST",
      url: "/deliveryValid",
      data:  {postcode: $("#address").val()},
      success: function(data) {
        if (data["answer"] != "no") {
          console.log(data)
          pickDateTime()
          displaySlots()
        } else {
          invalidArea()
        };
        },
      error : function(resultat, statut, erreur){console.log("erreur POST LALALLALALs")},
      dataType: 'json'
  });
}


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
