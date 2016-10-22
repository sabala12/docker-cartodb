/**
 * Created by eran on 15/10/16.
 */

const fs = require('fs');
const Path = require('path');

var handle = function(path) {
    this.path = Path.resolve(path);
};

handle.prototype.load = function() {
    return new Error('not implemented!');
};

handle.prototype.save = function(path, data, callback) {
    fs.writeFile(path, data, function(err) {
        if(err) {
            callback(err)
        }
    });
};

handle.prototype.serializes = function (obj, callback) {
    return new Error('not implemented!');
};

module.exports = handle;