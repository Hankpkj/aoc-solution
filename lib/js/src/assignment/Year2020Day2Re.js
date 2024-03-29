// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Input = require("../Util/input.js");
var Belt_Int = require("rescript/lib/js/belt_Int.js");
var Belt_List = require("rescript/lib/js/belt_List.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");

var input = Input.Input.getInput(/* Single */0, 2);

var li = Belt_List.fromArray(input);

function id(a) {
  return a;
}

function split(string) {
  return Belt_Array.keepMap(string.split(/-|\s|:\s/g), id);
}

function intStringToInt(s) {
  return Belt_Option.getExn(Belt_Int.fromString(s));
}

function parsing(fullString) {
  var match = split(fullString);
  if (match.length !== 4) {
    return ;
  }
  var a = match[0];
  var b = match[1];
  var c = match[2];
  var d = match[3];
  return {
          low: Belt_Option.getExn(Belt_Int.fromString(a)),
          high: Belt_Option.getExn(Belt_Int.fromString(b)),
          target: c,
          source: d
        };
}

function judgeX(p) {
  var target = p.target;
  var cnt = Belt_Array.keep(p.source.split(""), (function (x) {
          return x === target;
        })).length;
  if (cnt >= p.low) {
    return cnt <= p.high;
  } else {
    return false;
  }
}

function judgeY(p) {
  var target = p.target;
  var sourceToArr = p.source.split("");
  var lowCharIsTarget = Belt_Array.getExn(sourceToArr, p.low - 1 | 0) === target;
  var highCharIsTarget = Belt_Array.getExn(sourceToArr, p.high - 1 | 0) === target;
  return lowCharIsTarget !== highCharIsTarget;
}

console.log(Belt_List.size(Belt_List.keep(Belt_List.keepMap(li, parsing), judgeX)));

console.log(Belt_List.size(Belt_List.keep(Belt_List.keepMap(li, parsing), judgeY)));

exports.input = input;
exports.li = li;
exports.id = id;
exports.split = split;
exports.intStringToInt = intStringToInt;
exports.parsing = parsing;
exports.judgeX = judgeX;
exports.judgeY = judgeY;
/* input Not a pure module */
