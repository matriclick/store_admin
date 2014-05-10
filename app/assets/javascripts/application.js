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
//= require jquery.cookie
//= require bootstrap-datepicker
//= require twitter/bootstrap
//= require turbolinks
//= require jquery_nested_form
//= require_tree .

$(document).ready(function() {
	if($.cookie("time_zone") == null) {
    	$.ajax({
           url: "/set_time_zone",
           type: "POST",
           dataType: "html",
		   headers: {
		      'X-Transaction': 'POST Timezone',
		      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
           data: { 'time_zone_name': jstz.determine().name() }
           });
	}
	
	$('.datepicker').datepicker({
		format: "yyyy-mm-dd"
	});
})
