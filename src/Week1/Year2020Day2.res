let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day2.sample.txt")

let li = input -> Js.String2.split("\n") -> Belt.List.fromArray
// li : list{ '1-10 q: qqqcmqfjqs', ... }


// process : list -> map(parsing) -> keep(judge) -> count -> log
type policy = {
    low: int,
    high: int,
    target: string,
    source: string,
}

let makeSureString = (o) => o ->Belt.Option.mapWithDefault("", x => x)
let makeSureInt = (o) => o ->Belt.Option.mapWithDefault(0, x => x)

let split = (string) => string
    ->Js.String2.splitByRe(%re("/[ :\s | \- | \s ]/g")) 
    ->Belt.Array.keep(nullable => makeSureString(nullable) !== "")
    ->Belt.Array.map(makeSureString) // make Array<not empty string>

let intStringToInt = (s) => s ->Belt.Int.fromString ->makeSureInt

let parsing = (fullString) => {
    let splitted = fullString ->split ->Belt.List.fromArray // :: Array<not empty string>
    switch splitted {
    | list{a,b,c,d} => {
        let intA = a ->intStringToInt
        let intB = b ->intStringToInt
        (intA, intB, c, d)
    }
    | _ => (-1, -1, "", "")
    }
}

let judgeX = (policy) => {
    let (low, high, target, source) = policy
    let cnt = source ->Js.String2.split("") ->Belt.List.fromArray ->Belt.List.keep(x => x === target) ->Belt.List.size
    (cnt >= low && cnt <= high)
}

let judgeY = (policy) => {
    let (low, high, target, source) = policy
    let sourceToArr = source ->Js.String2.split("")
    let first = sourceToArr ->Belt.Array.get(low-1) ->Belt_Option.mapWithDefault("Not Found", x => x) === target
    let second = sourceToArr ->Belt.Array.get(high-1) ->Belt_Option.mapWithDefault("Not Found", x => x) === target
    (first !== second)
}

// example 1 answer
li 
->Belt.List.map(parsing)
->Belt.List.keep(judgeX)
->Belt.List.size 
->Js.log

// example 2 answer
li
->Belt.List.map(parsing)
->Belt.List.keep(judgeY)
->Belt.List.size 
->Js.log


