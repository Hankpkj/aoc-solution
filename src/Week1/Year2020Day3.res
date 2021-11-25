let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day3.sample.txt")

let arr = input->Js.String2.split("\n")->Belt.List.fromArray
let rowLength = arr->Belt.List.head->Belt.Option.mapWithDefault(0, Js.String2.length)

// 1. specific version

let specific = () =>
  arr // call by name ?
  ->Belt.List.keep(a => a !== "")
  ->Belt.List.map(str => str->Js.String2.split(""))
  ->Belt.List.mapWithIndex((idx, arr) => {
    arr[idx * 3 - idx * 3 / rowLength * rowLength]
  })
  ->Belt.List.keep(x => x === "#")
  ->Belt.List.length

// 2. general version

type direction = {row: int, col: int}

let findTrees = (arr: list<string>, dir: direction) => {
  let {row, col} = dir
  let rowLength = arr->Belt.List.head->Belt.Option.map(Js.String2.length)

  switch rowLength {
  // Nullable
  | None => 0
  | Some(length) =>
    arr
    ->Belt.List.keepWithIndex((_, idx) => mod(idx, row) === 0)
    ->Belt.List.keep(a => a !== "")
    ->Belt.List.map(str => str->Js.String2.split(""))
    ->Belt.List.mapWithIndex((idx, arr) => arr[mod(idx * col, length)])
    ->Belt.List.keep(x => x === "#")
    ->Belt.List.length
  }
}

let directions: list<direction> = list{
  // given by Aoc
  {row: 1, col: 1},
  {row: 1, col: 3},
  {row: 1, col: 5},
  {row: 1, col: 7},
  {row: 2, col: 1},
}

let parser = findTrees(arr)
directions->Belt.List.map(parser)->Belt.List.reduce(1, (acc, cur) => acc * cur)->Js.log
