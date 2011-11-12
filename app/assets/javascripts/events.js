// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


function attach_events() {
  $('.edit-event').click(function() {
    $('.ui-tooltip').hide();
    
    
    
    jQuery.ajax({
                      type: 'get',
                      url: "/events/" + this.id + "/edit",
                      success: function() {
                        $('#errors').hide();
                        $('#modal-from-dom').modal({
                           show : true,
                           keyboard : true,
                           backdrop : true
                        });
                        
                        $('.edit_event').bind('ajax:error', function(evt, xhr, status, error){
                          var responseObject = $.parseJSON(xhr.responseText),
                          errors = $('<ul />');

                          $.each(responseObject, function(name, error){
                            errors.append('<li>' + name + ' ' + error + '</li>');
                          })

                          $('#errors').html(errors).show();
                          $('#modal-from-dom').effect("shake", { times:2 }, 100);
                        })

                        $('.edit_event').bind('ajax:success', function() {  
                          $('#calendar').fullCalendar( 'refetchEvents');
                          $('#modal-from-dom').modal('hide');
                        });
                        
                      }
                  });
    
    
    
     return false;
  });
  
  $('.delete-event').click(function() {
    $('.ui-tooltip').hide();
    
    $('#modal-from-dom').load("/events/" + this.id + "/delete_confirmation", function() {
        $('#modal-from-dom').modal({
           show : true,
           keyboard : true,
           backdrop : true
        });
    });
   
    
    
    
     return false;
  });
}

$(document).ready(function(){ 

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

      
           
      $('#calendar').fullCalendar({
          editable: false,
          header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,agendaWeek,agendaDay'
          },
          defaultView: 'month',
          height: 500,
          loading: function(bool){
              if (bool) 
                  $('#loading').show();
              else 
                  $('#loading').hide();
          },
          
          events: "/events/retrieve",
          timeFormat: 'h:mm t{ - h:mm t} ',
        
          eventRender: function(event, element) {
                  element.qtip({
                    position: {
                       my: 'bottom-center',
                       at: 'top-center',
                    },
                      show: {
                            event: 'click',
                            solo: true,
                            modal: true,
                      },
        
                       hide: {
                          event: 'click',
                          target: $('.close')
                        },
                      style: {
                         classes: 'ui-tooltip-shadow ui-tooltip-light'
                      },
                      my: 'bottom center',
                      at: 'top center',
                      content: {
                            text: 'Loading...', // The text to use whilst the AJAX request is loading
                            ajax: {
                               url:  "/events/" + event.id + '/popup', // URL to the local file
                               type: 'GET', // POST or GET
                               
                            }
                         },
                         
                  });
              },
          




      });
  });

