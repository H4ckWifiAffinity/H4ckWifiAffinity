"use strict"

$(document).ready(function() {
    renderMap();
});

function renderMap(){
    var devicesData,
        heatmap,
        router_image;

    heatmap = new HeatCanvas("canv");
    heatmap.onRenderingStart = function(){document.getElementById('status').innerHTML = 'rendering...'}
    heatmap.onRenderingEnd = function(){
        router_image = new Image();
        router_image.src = '/images/router.png';
        router_image.onload = function(){
            document.getElementById("canv").getContext("2d").drawImage(router_image, 370, 270);
        };
        document.getElementById('status').innerHTML = 'done'
    };

    $.getJSON( '/api/devicelist', function( data ) {
        $.each(data, function(){
            var x = Math.floor(Math.random() * heatmap.width);
            var y = Math.floor(Math.random() * heatmap.height);
            console.log(this.averageSignal.toFixed(0)*-1)
            addData(x, y, this.averageSignal.toFixed(0)*-1  , heatmap);
        });
        var colorscheme = function(value){
            var h = (1 - value);
            var l = value * 0.6;
            var s = 0.8;
            var a = 1;
            return [h, s, l, a];
        }
        heatmap.bgcolor = [250, 250, 250, 255];
        heatmap.render(1, null, colorscheme );
    });

}
function addData(x, y, v, heatmap){
    // push data into the map
    heatmap.push(x, y, v);

    document.getElementById("canv").getContext("2d").fillText(v, x, y);
    //document.getElementById("info").innerHTML= "x:"+x+", y:"+y+", value:"+v;
}
