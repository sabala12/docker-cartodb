/**
 * Created by eran on 15/10/16.
 */

const Handle = require('./../handle');

var load = function() {
    try {
        this.object = require(this.path);
    } catch (e) {
        this.object = new Error("unable to load config");
    }
};

var serialize = function(obj, callback) {
    var jsonStr = JSON.stringify(obj, null, 4);
    var str = "module.exports = " + jsonStr + ";";
    callback(null, str);
};

var JS = function(path) {
    Handle.call(this, path);
    this.load();
};

JS.prototype = Object.create(Handle.prototype);
JS.prototype.constructor = JS;
JS.prototype.load = load;
JS.prototype.serialize = serialize;

module.exports = JS;