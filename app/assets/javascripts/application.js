// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap

// The JS/AJAX code below is what the 'remote: true' (in the view template will do for you).  Whatever you write beyond is the '3. Handle the response' portion of the code.
// $(document).ready(function() {
//   $('#hit_form input').click(function() { // 1. Unobstrusive javascript event listener
//     $.ajax({ // 2. Trigger ajax request
//       type: 'POST',
//       url: '/player/hit'
//       data: {param1: "hi", param2: 'there'}
//     }).done(function(msg) { // 3. Handle the response
//       $('#some_element').html(msg);
//     })
//   });
// });