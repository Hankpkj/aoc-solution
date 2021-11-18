// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Belt_List = require("rescript/lib/js/belt_List.js");
var Belt_SetString = require("rescript/lib/js/belt_SetString.js");

var input = Fs.readFileSync("input/Week1/Year2020Day6.sample.txt", "utf8");

function blankReplaceNewline(s) {
  if (s === "") {
    return "\n";
  } else {
    return s;
  }
}

function splitBy(s) {
  return function (param) {
    return s.split(param);
  };
}

var s = input.split("\n").map(blankReplaceNewline).join("");

var list = Belt_List.fromArray(s.split("\n"));

function getCharSetSize(s) {
  return Belt_SetString.size(Belt_SetString.fromArray(s.split("")));
}

function sum(a, b) {
  return a + b | 0;
}

console.log(Belt_List.reduce(Belt_List.map(list, getCharSetSize), 0, sum));

exports.input = input;
exports.blankReplaceNewline = blankReplaceNewline;
exports.splitBy = splitBy;
exports.list = list;
exports.getCharSetSize = getCharSetSize;
exports.sum = sum;
/* input Not a pure module */