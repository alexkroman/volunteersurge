// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require_tree
//= require jquery-ui
//= require jquery.ui.datepicker
//= require jquery.timePicker.min
//= require fullcalendar
//= require bootstrap-modal
//= require bootstrap-alerts
//= require bootstrap-twipsy
//= require bootstrap-popover
//= require bootstrap-dropdown
//= require bootstrap-scrollspy
//= require bootstrap-tabs
//= require gcal

$(document).ready(function(){ 
	$( ".button" ).button();
});


function editEvent(event_id){
    jQuery.ajax({
        dataType: 'script',
        type: 'get',
        url: "/events/" + event_id + "/edit"
    });
}

function deleteEvent(event_id, delete_all){
    jQuery.ajax({
        data: '_method=delete&delete_all=' + delete_all,
        dataType: 'script',
        type: 'post',
        url: "/events/" + event_id,
		  success: function() {
    			$('#calendar').fullCalendar( 'refetchEvents');
				$('#desc_dialog').dialog('destroy');
  		  }
    });
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }  
}
