// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");

function getInput(t, fileNum) {
  var newLineString = "\n";
  var splitStr = t ? newLineString.repeat(2) : newLineString;
  return Fs.readFileSync("input/Year2020Day" + String(fileNum) + ".sample.txt", "utf8").split(splitStr);
}

var Input = {
  getInput: getInput
};

exports.Input = Input;
/* fs Not a pure module */
