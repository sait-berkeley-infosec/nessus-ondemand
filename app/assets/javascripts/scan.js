// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
    $('#datepicker').datepicker();
});
$('#datepicker').change(function() {
    $('#datepicker').html(moment($(this), 'MM/DD/YYYY').format('dddd'));
});
