/**
 * Created by eran on 15/10/16.
 */

const Path = require('path');
const Handle = require('./handle');
const JsHandle = require('./handles/js');
const JsonHandle = require('./handles/json');
const YamlHandle = require('./handles/yaml');

var create = function(source) {
    const ext = Path.extname(source);

    var result = {};
    if (ext == ".js") {
        result.value = new JsHandle(source);
    } else if (ext == ".json") {
        result.value = new JsonHandle(source);
    } else if (ext == ".yml") {
        result.value = new YamlHandle(source);
    } else {
        result.err = new Error("no suitable handle was found!")
    }

    return result;
};

module.exports = {
    create: create
};
