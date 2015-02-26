var express = require('express');
var router = express.Router();


/*
 * POST to add raw dump.
 */
router.post('/adddump', function(req, res) {
    var db = req.db;
    console.log("-------------------------------------------------------------");
    console.log(req.body);
    db.collection('raw_dump').insert(req.body, function(err, result){
        console.log("----------------------// dump added //-----------------------");
        res.send(
            (err === null) ? { msg: '' } : { msg: err }
        );
    });
});

/*
 * GET deviceList.
 */
router.get('/devicelist', function(req, res) {
    var db = req.db;
    //db.collection('raw_dump').aggregate(
    //    [
    //        {
    //            $group : {
    //                _id :  "$src" ,
    //                averageSignal: { $avg: "$signal" },
    //                count: { $sum: 1 }
    //            }
    //        }
    //    ]
    //).toArray(function (err, items) {
    //    console.log(items);
    //    res.json(items);
    //});
    db.collection('raw_dump').aggregate(
        {
            $match : {type : "request"}
        },
        {
            $group : {_id : "$src", averageSignal: { $avg: "$signal" }, count : { $sum : 1 }}
    },function(err, years) {
        res.json(years);
    });
});


module.exports = router;


