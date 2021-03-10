// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//= require jquery-1.12.4.js
//= require autocomplete/autocomplete-1.12.1.js
//= require jquery-migrate-1.2.1.min.js
//= require jquery.autocomplete.js
//= require jquery_i18n
//= require bootstrap.min.js

if (typeof jQuery !== 'undefined') {
	(function($) {
		$('#spinner').ajaxStart(function() {
			$(this).fadeIn();
		}).ajaxStop(function() {
			$(this).fadeOut();
		});
	})(jQuery);
}

$(document).ready(function() {
	// trigger bootstrap tooltip (for image icon in results list)
	$('.avhRowB i[data-toggle="tooltip"]').tooltip();
});
