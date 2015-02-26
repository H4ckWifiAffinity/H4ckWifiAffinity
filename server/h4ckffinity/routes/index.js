var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

/* GET Hello World page. */
router.get('/devices', function(req, res) {
    res.render('devices', { title: 'List of listened devices' });
});

module.exports = router;
