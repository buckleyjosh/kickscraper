$(document).ready(function() {
  $("input[type=submit].delete").click(function() {
    var id = $(this).attr('id')
    $.get(id + '/delete', function(data) {
        $("#" + id).closest("tr").fadeOut();
    });
  });

  $("input[type=submit].contact").click(function() {
    var id = $(this).attr('id')
    $.get(id + '/contact', function(data) {
        var record = $("#" + id).closest("tr");
        record.fadeOut().find('td.contact').remove();
        $("tbody.contact_table").append('<tr>' + record.html() + '</tr>');
    });
  });
});