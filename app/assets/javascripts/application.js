// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require bootstrap-twipsy
//= require_tree
//= require jquery-ui
//= require jquery.ui.datepicker
//= require fullcalendar
//= require bootstrap-modal
//= require bootstrap-alerts
//= require bootstrap-popover
//= require bootstrap-dropdown
//= require bootstrap-scrollspy
//= require bootstrap-tabs
//= require gcal
//= require jquery.timePicker
//= require jquery.qtip
//= require autocomplete-rails

$('#new-event').click(function() {

  $('.ui-tooltip').hide();

  $('#modal-from-dom').load("/events/new", function() {
    $('#errors').hide();
    $('#modal-from-dom').modal({
      show : true,
      keyboard : true,
      backdrop : true
    });

    $('#new_event').bind('ajax:error', function(evt, xhr, status, error){
      var responseObject = $.parseJSON(xhr.responseText),
      errors = $('<ul />');

      $.each(responseObject, function(name, error){
        errors.append('<li>' + name + ' ' + error + '</li>');
      })

      $('#errors').html(errors).show();
      $('#modal-from-dom').effect("shake", { times:2 }, 100);
    })

    $('#new_event').bind('ajax:success', function() {  
      $('#calendar').fullCalendar( 'refetchEvents');
      $('#modal-from-dom').modal('hide');
    });


  });


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
            $('.frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('.frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('.frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('.frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }  
}
