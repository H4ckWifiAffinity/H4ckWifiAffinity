$(document).ready(function() {

    // Populate the device table on initial page load
    populateTable();

});

function populateTable() {

    // Empty content string
    var tableContent = '';

    // jQuery AJAX call for JSON
    $.getJSON( '/api/devicelist', function( data ) {

        // For each item in our JSON, add a table row and cells to the content string
        $.each(data, function(){
            tableContent += '<tr>';
            tableContent += '<td><a href="#" class="linkshowdetails" rel="' + this._id + '">' + this._id + '</a></td>';
            tableContent += '<td>' + this.averageSignal.toFixed(0) + '</td>';
            tableContent += '<td>' + this.count + '</td>';
            tableContent += '</tr>';
        });

        // Inject the whole content string into our existing HTML table
        $('#deviceList table tbody').html(tableContent);
    });
};
