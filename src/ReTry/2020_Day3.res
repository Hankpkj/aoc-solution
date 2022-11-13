open Input
open Belt
let input = Input.getInput(Input.Single, 3)
let twoDimensionArray = input->Array.map(a => a->Js.String2.split(""))

let findTree = ((x, y)) =>
  twoDimensionArray
  ->Array.keepWithIndex((_, index) => mod(index, y) == 0)
  ->Array.mapWithIndex((index, arr) => {
    let length = arr->Array.length
    let targetX = mod(index * x, length)
    arr->Array.get(targetX)->Option.getWithDefault("")
  })
  ->Array.keep(str => str == "#")
  ->Array.length

// answer 1
findTree((3, 1))->Js.log

// answer 2
let directions = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

directions->Array.map(findTree)->Array.reduce(1, (acc, cur) => acc * cur)->Js.log
