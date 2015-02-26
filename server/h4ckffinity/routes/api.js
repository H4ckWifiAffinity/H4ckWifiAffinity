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


module.exports = router;


