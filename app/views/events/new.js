$('#create_event_dialog').dialog({
        title: 'New Event',
        modal: true,
        width: 500,
        close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
    });