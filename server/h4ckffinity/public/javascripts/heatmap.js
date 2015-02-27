"use strict"

$(document).ready(function() {
    renderMap();
});

function renderMap() {
    var devicesData,
        canvas,
        heatmap,
        router_image;

    //router_image = new Image();
    //router_image.src = '/images/router.png';
    //router_image.onload = function () {
    //    document.getElementById("canv").getContext("2d").drawImage(router_image, 370, 270);
    //};

    canvas = document.getElementById("canv");
    heatmap = createWebGLHeatmap({canvas: canvas, intensityToAlpha: true});
    //var heatmap = createWebGLHeatmap({canvas: canvas, intensityToAlpha:true, alphaRange: [1, 0]}); // inverse transparency
    //var heatmap = createWebGLHeatmap({canvas: canvas, intensityToAlpha:true, alphaRange: [0, 0.05]}); // steep transparency
    //var heatmap = createWebGLHeatmap({canvas: canvas, intensityToAlpha:true, gradientTexture:'deep-sea-gradient.png'});
    //var heatmap = createWebGLHeatmap({canvas: canvas, intensityToAlpha:false, gradientTexture:'skyline-gradient.png'});
    //var heatmap = createWebGLHeatmap({width: 500, height: 500}); // statically sized heatmap
    document.body.appendChild(heatmap.canvas);

    //To add a random value to heach point
    //var paintAtCoord = function (x, y) {
    //    var count = 0;
    //    while (count < 200) {
    //        var xoff = Math.random() * 2 - 1;
    //        var yoff = Math.random() * 2 - 1;
    //        var l = xoff * xoff + yoff * yoff;
    //        if (l > 1) {
    //            continue;
    //        }
    //        var ls = Math.sqrt(l);
    //        xoff /= ls;
    //        yoff /= ls;
    //        xoff *= 1 - l;
    //        yoff *= 1 - l;
    //        count += 1;
    //        console.log(xoff* 50);
    //        console.log(yoff* 50);
    //        heatmap.addPoint(x + xoff * 50, y + yoff * 50, 30, 2 / 300);
    //    }
    //
    //}


    var raf = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
        window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;
        var update = function () {
        //heatmap.addPoint(100, 100, 100, 10/255);
        //heatmap.adjustSize(); // can be commented out for statically sized heatmaps, resize clears the map
        heatmap.update(); // adds the buffered points
        heatmap.display(); // adds the buffered points
        //heatmap.multiply(0.9995);
        //heatmap.blur();
        //heatmap.clamp(0.0, 1.0); // depending on usecase you might want to clamp it
        raf(update);
    }
    raf(update);

      canvas.onclick = function () {
        heatmap.clear();
    }

    var center_x = canvas.width / 2,
        center_y = canvas.height / 2,
        max_radius = center_x > center_y ? center_y : center_x,
        max_ssi = -65,
        min_ssi = -40;
    console.log(center_x);
    console.log(center_y);
    console.log(max_radius);


    //setInterval(function(){
        $.getJSON('/api/devicelist', function (data) {
            $.each(data, function ( index, value ) {
                //if (index % 2 == 0) {
                    var avg_ssi = value.averageSignal.toFixed(0) * -1,
                        normalized_ssi = (avg_ssi + min_ssi) * (max_radius / -(max_ssi - min_ssi));
                    //console.log('avg: ' + avg_ssi);
                    //console.log('fixed_ssi: ' + normalized_ssi);

                    heatmap.addPoint(center_x, center_y, normalized_ssi  * 5, 0.1);
                //}

            });
        });
    //}, 1000);


}

