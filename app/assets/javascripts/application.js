//= require rails-ujs
//= require underscore
//= require gmaps/google
//= require algolia/v3/algoliasearch.min
//= require jquery
//= require moment
//= require fullcalendar
//= require bootstrap-datepicker
//= require_tree .


// var algoliasearch = require('algoliasearch');
// var algoliasearch = require('algoliasearch/reactnative');
// var algoliasearch = require('algoliasearch/lite');
// or just use algoliasearch if you are using a <script> tag
// if you are using AMD module loader, algoliasearch will not be defined in window,
// but in the AMD modules of the page

$('document').ready(function(){
      $('.datepicker').datepicker({
        clearBtn: true,
        todayHighlight: true,
        startDate: new Date() + 1,
        autoclose: true,
        // datesdisabled : <%= @unavailabledates %>
      });
      $('#calendar').fullCalendar({});
    });
