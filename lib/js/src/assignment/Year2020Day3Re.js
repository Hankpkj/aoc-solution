// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Input = require("../Util/input.js");
var Belt_List = require("rescript/lib/js/belt_List.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Caml_int32 = require("rescript/lib/js/caml_int32.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");

var input = Input.Input.getInput(/* Single */0, 3);

var li = Belt_List.fromArray(input);

function id(t) {
  return t;
}

var rowLength = Belt_Option.mapWithDefault(Belt_List.head(li), 0, (function (prim) {
        return prim.length;
      }));

function specific(li) {
  return Belt_List.length(Belt_List.keep(Belt_List.keepMap(Belt_List.mapWithIndex(Belt_List.map(Belt_List.keep(li, (function (a) {
                                    return a !== "";
                                  })), (function (str) {
                                return str.split("");
                              })), (function (idx, arr) {
                            return Belt_Array.get(arr, Math.imul(idx, 3) - Math.imul(Caml_int32.div(Math.imul(idx, 3), rowLength), rowLength) | 0);
                          })), id), (function (x) {
                    return x === "#";
                  })));
}

console.log(specific(li));

function findTrees(list, dir) {
  return Belt_List.length(Belt_List.keep(Belt_List.keepMap(Belt_List.mapWithIndex(Belt_List.map(Belt_List.keep(Belt_List.keepWithIndex(list, (function (param, idx) {
                                        return Caml_int32.mod_(idx, dir.row) === 0;
                                      })), (function (a) {
                                    return a !== "";
                                  })), (function (str) {
                                return str.split("");
                              })), (function (idx, arr) {
                            return Belt_Array.get(arr, Caml_int32.mod_(Math.imul(idx, dir.col), Belt_List.headExn(list).length));
                          })), id), (function (x) {
                    return x === "#";
                  })));
}

var directions = {
  hd: {
    row: 1,
    col: 1
  },
  tl: {
    hd: {
      row: 1,
      col: 3
    },
    tl: {
      hd: {
        row: 1,
        col: 5
      },
      tl: {
        hd: {
          row: 1,
          col: 7
        },
        tl: {
          hd: {
            row: 2,
            col: 1
          },
          tl: /* [] */0
        }
      }
    }
  }
};

function withList(param) {
  return findTrees(li, param);
}

console.log(Belt_List.reduce(Belt_List.map(directions, withList), 1, (function (acc, cur) {
            return Math.imul(acc, cur);
          })));

exports.input = input;
exports.li = li;
exports.id = id;
exports.rowLength = rowLength;
exports.specific = specific;
exports.findTrees = findTrees;
exports.directions = directions;
exports.withList = withList;
/* input Not a pure module */
