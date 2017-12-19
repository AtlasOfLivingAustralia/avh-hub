// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//= require jquery-1.12.4.js
//= require jquery.autocomplete.js
//= require jquery-migrate-1.2.1.min.js
//= require jquery_i18n
// require jquery.autocomplete
//= require bootstrap.min.js

// require hubCore
// require bootstrap.js
// require html5.js
// require_full_tree
// require_tree .
// require leafletPlugins.js
// require_self


if (typeof jQuery !== 'undefined') {
	(function($) {
		$('#spinner').ajaxStart(function() {
			$(this).fadeIn();
		}).ajaxStop(function() {
			$(this).fadeOut();
		});
	})(jQuery);
}
