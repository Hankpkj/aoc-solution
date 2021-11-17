let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day5.sample.txt")

let li = input -> Js.String2.split("\n") 
                -> Belt.List.fromArray

type range = {
    start: int,
    mid: int,
    end: int
}

let findRange : (range, bool) => range = (r: range, signLeft: bool) => {
    let {start, mid, end} = r
    switch signLeft {
    | true => {start: start, mid: ((start + mid ) / 2), end: mid}
    | false => {start: mid+1, mid: (((mid + 1)+ end ) / 2), end: end}
    }
}

let initRowRange : range = {
    start: 0, mid: 63, end: 127
}

let initColRange : range = {
    start: 0, mid: 3, end: 7
}

let ids = li -> Belt.List.map((str) => {
    let splitted = str -> Js.String2.split("")
        -> Belt.List.fromArray
        -> Belt.List.splitAt(7)
    switch splitted {
    | None => 0
    | Some(fb, lr) => {
        let row = Belt.List.reduce(fb, initRowRange, (acc, cur) => findRange(acc, cur === "F")).mid
        let col = Belt.List.reduce(lr, initColRange, (acc, cur) => findRange(acc, cur === "L")).mid
        row * 8 + col
        }
    }
})
 -> Belt.List.toArray
 
let max = ids -> Js.Math.maxMany_int

// example 1 answer 
max -> Js.log

let sorted = Js.Array.sortInPlaceWith((n1, n2) => n1 - n2, ids) -> Belt.List.fromArray

let head = sorted -> Belt.List.headExn

let mySeat = sorted -> Belt.List.reduce(head, (acc, cur) => 
    if acc + 1 === cur {cur} else {acc}
) + 1

// example 2 answer 
mySeat -> Js.log



