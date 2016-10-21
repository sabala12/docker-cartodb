/**
 * Created by eran on 15/10/16.
 */

const getenv = require('getenv');

const transformEnvs = function(obj) {

    var regex = /(\${\w*})/;
    for(var key in obj) {
        var val = obj[key];
        if (val instanceof Object) {
            transformEnvs(val);
        } else {
            while((result = regex.exec(val)) != null) {
                result = result[0];
                var env = result.substring(2, result.length - 1);
                var env_val = getenv(env);
                val = val.replace(regex, env_val);
            }
            obj[key] = val;
        }
    }
};

module.exports = {
    transformEnvs: transformEnvs
};