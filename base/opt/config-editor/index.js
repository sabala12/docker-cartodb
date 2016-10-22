const commandLineArgs = require('command-line-args');
const fs              = require('fs');
const merge           = require('merge');
const handlesFactory = require('./lib/handlesFactory');
const editor = require('./lib/editor');

const optionDefinitions = [
    { name: 'source', type: String },
    { name: 'override', type: String }
];

function validateHandler(result) {
    if (result.err) {
        console.log(result.err);
        process.exit(1)
    }
}

const options = commandLineArgs(optionDefinitions);
const source = options.source;
const override = options.override;

var sourceHandle = handlesFactory.create(source);
validateHandler(sourceHandle);
var overrideHandle = handlesFactory.create(override);
validateHandler(overrideHandle);

sourceHandle = sourceHandle.value;
overrideHandle = overrideHandle.value;

editor.transformEnvs(sourceHandle.object);
editor.transformEnvs(overrideHandle.object);

var mergedObj = merge.recursive(sourceHandle.object, overrideHandle.object);
sourceHandle.serialize(mergedObj, function (err, str) {
    sourceHandle.save(sourceHandle.path, str, function (err) {
        if (err) {
            console.log(err);
            process.exit(2)
        }
    });
});