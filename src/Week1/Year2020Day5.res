let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day5.sample.txt")

let li = input -> Js.String2.split("\n") 
                -> Belt.List.fromArray

type range = {
    start: int,
    mid: int,
    end: int
}

let findRange = (r, signLeft) => {
    let {start, mid, end} = r
    signLeft
        ? {start: start, mid: ((start + mid ) / 2), end: mid}
        : {start: mid+1, mid: (((mid + 1)+ end ) / 2), end: end}
}

let initRowRange : range = {
    start: 0, mid: 63, end: 127
}

let initColRange : range = {
    start: 0, mid: 3, end: 7
}

// FBFFBFFLLR
// 1011011110 TODO: try binary shift 

let findMid = (r, ir, c) => Belt.List.reduce(r, ir, (acc, cur) 
                         => findRange(acc, cur === c)).mid

let ids = li -> Belt.List.map((str) => {
    let splitted = str -> Js.String2.split("")
        -> Belt.List.fromArray
        -> Belt.List.splitAt(7)
    
    splitted -> Belt.Option.mapWithDefault(0, ((fb, lr)) => {
        let row = findMid(fb, initRowRange, "F")
        let col = findMid(lr, initColRange, "L")
        row * 8 + col
    })
})
 -> Belt.List.toArray
 
let max = ids -> Js.Math.maxMany_int

// example 1 answer 
max -> Js.log

let sorted = ids -> Belt.SortArray.stableSortBy((a, z) => a - z) 
                 -> Belt.List.fromArray

let slidingWindow = sorted->Belt.List.tail->Belt.Option.mapWithDefault(
    list{},
    (tails) => Belt.List.zip(sorted, tails)
)

let keeping = slidingWindow -> Belt.List.keep(((a, b)) => b - a !== 1) 
                            -> Belt.List.map(((a, b)) => (a + b) / 2) 
                            -> Belt.List.head

// example 2 answer                         
switch keeping {
| Some(value) => Js.log(value)
| None => Js.log("Not Found")
}
                            



