/**
 * Created by eran on 15/10/16.
 */

const Handle = require('./../handle');
const fs = require('fs');

var load = function() {
    try {
        fs.readFile(this.path, 'utf8', function (err, data) {
            if (err) {
                this.object = new Error("unable to load config");
            }
            this.object = JSON.parse(data);
        });
    } catch (e) {
        this.object = new Error("unable to load config");
    }
};

var serialize = function(obj, callback) {
    callback(null, JSON.stringify(obj));
};

var Json = function(path) {
    Handle.call(this, path);
    this.load();
};

Json.prototype = Object.create(Handle.prototype);
Json.prototype.constructor = Json;
Json.prototype.load = load;
Json.prototype.serialize = serialize;

module.exports = Json;