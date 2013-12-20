# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#uploads_in_progress').hide()
  $('#upload_asset').fileupload
    dataType: "script"
    add: (e, data) ->
      file = data.files[0]
      data.context = $(tmpl("template-upload", file))
      $('#uploads_in_progress').show()
      $('#uploads_in_progress').append(data.context)
      data.submit()
    progress: (e, data) ->
      if data.context
        file = data.files[0]
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
        data.context.find('.data-loaded').html(data.loaded / 1000)
        data.context.find('.data-total').html(data.total / 1000)
        $('#progress-close').show()
  $('#progress-close').click ->
    $('#progress-close').hide()