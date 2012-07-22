$ ->
  $('[data-toggle="modal"]').click (event) ->
    event.preventDefault()
    href = $(this).attr('href')
    urlModal href

  #$("input.date").calendricalDate { usa: true }
  #$("input.time").calendricalTime { }
    
root = exports ? this
root.urlModal = (href) ->
  app_modal = $("div#app_modal")
  if app_modal[0]
    app_modal.modal('hide')
  if (href.indexOf('#') == 0)
    $(href).modal('open')
  else
    $.ajax href,
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, status, error) ->
        console.log "Error: #{status}"
      success: (data, status, jqXHR) ->
        if app_modal[0]
          app_modal.html(data)
          app_modal.modal('show')
        else
          $('<div class="modal" id="app_modal">' + data + '</div>').modal()
        $('input:text:visible:first').focus()
    
$("a[rel=tooltip]").tooltip()

$(".markitup").markItUp(mySettings)
