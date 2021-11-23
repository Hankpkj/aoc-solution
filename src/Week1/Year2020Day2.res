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

let id = a => a

let split = (string) => string
    ->Js.String2.splitByRe(%re("/[ :\s | \- | \s ]/g")) 
    ->Belt.Array.keepMap(id)

let intStringToInt = (s) => s->Belt.Int.fromString

let parsing = (fullString) => {
    let splitted = fullString -> split ->Belt.List.fromArray // :: Array<not empty string>
    switch splitted {
        // list{a,b,c,d}
    | list{a,b,c,d} => {
        a->intStringToInt->Belt.Option.flatMap(a => {
            b ->intStringToInt->Belt.Option.map(b => {
                { low: a, high: b, target: c, source: d }
            })
        })

    }
    | _ => None
    }
}

let judgeX = (policy) => {
    let cnt = policy.source ->Js.String2.split("") ->Belt.List.fromArray ->Belt.List.keep(x => x === policy.target) ->Belt.List.size
    (cnt >= policy.low && cnt <= policy.high)
}

let judgeY = (policy) => {
    let { low, high, target, source } = policy
    let sourceToArr = source ->Js.String2.split("")
    let first = sourceToArr ->Belt.Array.get(low-1) ->Belt_Option.mapWithDefault("Not Found", x => x) === target
    let second = sourceToArr ->Belt.Array.get(high-1) ->Belt_Option.mapWithDefault("Not Found", x => x) === target
    (first !== second)
}

// example 1 answer
li 
->Belt.List.keepMap(parsing)
->Belt.List.keep(judgeX)
->Belt.List.size 
->Js.log

// example 2 answer
li
->Belt.List.keepMap(parsing)
->Belt.List.keep(judgeY)
->Belt.List.size 
->Js.log

