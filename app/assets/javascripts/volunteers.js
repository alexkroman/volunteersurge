// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

jQuery(function($) {
 $("#live_search").keyup(function() {
	 delay(function(){
      $.post("/volunteers/search", { search: $('#live_search').val() },
		   function(data){
		   	$("#volunteer-results").html(data);
		 });
    }, 500 );
 });
})