/**
 * Created by eran on 15/10/16.
 */

const getenv = require('getenv');

const transformEnvs = function(obj) {

    var env_regex = /^\$\{\w*\}$/;
    for(var key in obj) {
        var val = obj[key];
        if (val instanceof Object) {
            transformEnvs(val);
        } else {
            if (env_regex.test(val)) {
                var env = val.substring(2, val.length - 1);
                obj[key] = getenv(env);
            }
        }
    }
};

module.exports = {
    transformEnvs: transformEnvs
};