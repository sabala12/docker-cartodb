/**
 * Created by eran on 15/10/16.
 */

const Handle = require('./../handle');
const YAML = require('yamljs');

var load = function() {
    this.object = YAML.load(this.path);
};

var serialize = function (obj, callback) {
    var str = YAML.stringify(obj, 4);
    callback(null, str);
};

var Yaml = function(path) {
    Handle.call(this, path);
    this.load();
};

Yaml.prototype = Object.create(Handle.prototype);
Yaml.prototype.constructor = Yaml;
Yaml.prototype.load = load;
Yaml.prototype.serialize = serialize;

module.exports = Yaml;
