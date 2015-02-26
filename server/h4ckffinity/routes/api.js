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
    db.collection('raw_dump').aggregate(
        {
            $match : {type : "request"}
        },
        {
            $group : {_id : "$src", averageSignal: { $avg: "$signal" }, count : { $sum : 1 }}
    },function(err, items) {
        res.json(items);
    });
});


/*
 * GET device frames.
 */
router.get('/deviceframes/:mac', function(req, res) {

    var db = req.db,
        r = /([a-f0-9]{2})([a-f0-9]{2})/i,
        mac = req.params.mac;
    while (r.test(mac)) {
        mac = mac.replace(r, '$1' + ':' + '$2');
    }
    db.collection('raw_dump').aggregate(
        {
            $match : {type : "request", src : mac}
        },function(err, frames) {
            res.json(frames);
        });
});

module.exports = router;


