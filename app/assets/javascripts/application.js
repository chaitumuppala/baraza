// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require lodash
//= require select2
//= require foundation
//= require loadjs
//= require ckeditor/init
//= require social-share-button
//= require common
//= require_tree ./jcrop
//= require_tree ./custom_js

$(function () {
  $(document).foundation({
    accordion: {
      // specify the class used for accordion panels
      content_class: 'content',
      // specify the class used for active (or open) accordion panels
      active_class: 'active',
      // allow multiple accordion panels to be active at the same time
      multi_expand: true,
      // allow accordion panels to be closed by clicking on their headers
      // setting to false only closes accordion panels when another is opened
      toggleable: true
    }
  });
});
