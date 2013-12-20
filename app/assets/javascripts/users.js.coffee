# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#user_allowing_user_ids').chosen()
  $('#user_allowed_user_ids').chosen()
  $('#start_date').datepicker
      dateFormat: 'yy-mm-dd'
    $('#end_date').datepicker
      dateFormat: 'yy-mm-dd'
  $('#search').typeahead
    source: $('#search').data('source')