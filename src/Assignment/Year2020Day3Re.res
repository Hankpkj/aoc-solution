open Input
let input = Input.getInput(Input.Single, 3)
open Belt
let li = input->List.fromArray
let id = t => t

// 1. specific version
let rowLength = li->List.head->Option.mapWithDefault(0, Js.String2.length)

let specific = li =>
  li
  ->List.keep(a => a !== "")
  ->List.map(str => str->Js.String2.split(""))
  ->List.mapWithIndex((idx, arr) => arr[idx * 3 - idx * 3 / rowLength * rowLength])
  ->List.keepMap(id)
  ->List.keep(x => x === "#")
  ->List.length

// answer
li->specific->Js.log

// 2. general version

type direction = {row: int, col: int}

let findTrees = (list, dir) =>
  list
  ->List.keepWithIndex((_, idx) => mod(idx, dir.row) === 0)
  ->List.keep(a => a !== "")
  ->List.map(str => str->Js.String2.split(""))
  ->List.mapWithIndex((idx, arr) => arr[mod(idx * dir.col, list->List.headExn->Js.String2.length)])
  ->List.keepMap(id)
  ->List.keep(x => x === "#")
  ->List.length

let directions: list<direction> = list{
  // given by Aoc
  {row: 1, col: 1},
  {row: 1, col: 3},
  {row: 1, col: 5},
  {row: 1, col: 7},
  {row: 2, col: 1},
}
// answer
let withList = li->findTrees
directions->List.map(withList)->List.reduce(1, (acc, cur) => acc * cur)->Js.log
