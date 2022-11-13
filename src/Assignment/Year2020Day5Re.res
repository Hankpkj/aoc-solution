open Input
let li = Input.getInput(Input.Single, 5)->Belt.List.fromArray

open Belt

type range = {
  start: int,
  mid: int,
  end: int,
}

let range = (start, mid, end) => { start, mid, end }

let findRange = ({ start, mid, end }: range, signLeft) => {
  signLeft 
  ? range(start, (start + mid) / 2, mid)
  : range(mid + 1, (mid + 1 + end) / 2, end)
}

let initRowRange = range(0, 63, 127)
let initColRange = range(0, 3, 7)

// FBFFBFFLLR
// 1011011110 TODO: try binary shift

let findMid = (r, ir, c): range => List.reduce(r, ir, (acc, cur) => findRange(acc, cur === c))
let ids =
  li
  ->List.map(str => {
    let splitted = str->Js.String2.split("")->Belt.List.fromArray->Belt.List.splitAt(7)
    splitted->Option.mapWithDefault(0, ((fb, lr)) => {
      let row = findMid(fb, initRowRange, "F").mid
      let col = findMid(lr, initColRange, "L").mid
      row * 8 + col
    })
  })
  ->List.toArray

let max = ids->Js.Math.maxMany_int

// example 1 answer
max->Js.log

let sorted = ids->SortArray.stableSortBy((a, z) => a - z)->List.fromArray

let slidingWindow =
  sorted->List.tail->Option.mapWithDefault(list{}, tails => List.zip(sorted, tails))

let keeping =
  slidingWindow->List.keep(((a, b)) => b - a !== 1)->List.map(((a, b)) => (a + b) / 2)->List.head

// example 2 answer
switch keeping {
| Some(value) => Js.log(value)
| None => Js.log("Not Found")
}
