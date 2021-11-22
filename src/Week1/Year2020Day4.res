// --- Given Input --- //
let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day4.sample.txt")

// process => parsing(string => setString) -> judge -> count -> log 

let require = ["byr", "hcl", "pid", "ecl", "iyr", "hgt", "eyr"] -> Belt_SetString.fromArray

// ---- example 1 ---- //
let parsing = (s) => s
    ->Js.String2.replaceByRe(%re("/[\s]+/g"), " ")  // make single line
    ->Js.String2.splitByRe(%re("/[\s]+/g"))         // split each item 
    ->Belt.Array.map(str => str -> Belt.Option.mapWithDefault("", x => x) -> Js.String2.replaceByRe(%re("/:[\w#]+/"), "")) // remove unuseful value not keys
    ->Belt.Array.keep(x => x !== "") // filter empty string
    ->Belt_SetString.fromArray // to set_string

let judge = (s) => s 
    ->Belt_SetString.intersect(require) 
    ->Belt_SetString.size
    === 7

input 
->Js.String2.split("\n\n") 
->Belt.List.fromArray
->Belt.List.map(parsing)
->Belt.List.keep(judge) 
->Belt.List.size 
->Js.log

// ---- example 2 ---- //

let toSingleLine = (s) => s ->Js.String2.replaceByRe(%re("/[\s]+/g"), " ")

let id = s => s

type twoElementTuple = (string, string)

let toTuple = s => switch s {
| [a_, b_] => Some(a_, b_)
| _ => None
}

let j = (p, s, f) => {
    let g = p -> Belt.Map.String.get(s)
    switch g {
    | Some(v) => v -> f
    | _ => false
    }
}

let parseToMap = (s) => s
->toSingleLine 
->Js.String2.splitByRe(%re("/[\s]+/g"))
->Belt.Array.keepMap(id)
->Belt.Array.map(s => s -> Js.String2.split(":"))
->Belt.Array.map(toTuple)
->Belt.Array.keepMap(id)
->Belt.Map.String.fromArray

let optionalNumberTest = (t, max, min) => {
    switch t {
    | Some(v) => (v <= max) && (v >= min)
    | _ => false
    }
}

let numberTestPair = list{("byr", (2002, 1920)), ("iyr", (2020, 2010)), ("eyr", (2030, 2020))}

let yearTest = m => numberTestPair 
->Belt.List.reduce(true, (acc, (key, (max, min))) => {
    let get = m ->Belt.Map.String.get(key)
    let result = switch get {
    | Some(v) => Js.Re.test_(%re("/^[1-9]{1}[0-9]{3}$/"), v) && v -> Belt.Int.fromString -> optionalNumberTest(max, min)
    | _ => false
    }
    result && acc
})


let regexTestPair = list{
    ("hcl", %re("/^#[a-f0-9]{6}$/")), 
    ("ecl", %re("/^(?:amb|blu|brn|gry|grn|hzl|oth)$/")), 
    ("pid", %re("/^[0-9]{9}/"))
}

let regexTest = m => 
regexTestPair 
->Belt.List.reduce(true, (acc, (key, re)) => {
    let get = m ->Belt.Map.String.get(key)
    let result = switch get {
    | Some(v) => Js.Re.test_(re, v)
    | _ => false
    }
    result && acc
})


let hgtRegexTest = v => 
    if Js.Re.test_(%re("/^[0-9]{2}(?:in)$/"), v) {v -> Belt.Int.fromString -> optionalNumberTest(76, 59) } else {
        if Js.Re.test_(%re("/^[0-9]{3}(?:cm)$/"), v) {v -> Belt.Int.fromString -> optionalNumberTest(193, 150) } else { false }
    }

let hgtTEst = (m) => {
    let get = m ->Belt.Map.String.get("hgt")
    switch get {
    | Some(v) => hgtRegexTest(v)
    | _ => false
    }
}

input 
->Js.String2.split("\n\n") 
->Belt.Array.map(parseToMap)
->Belt.Array.keep(yearTest)
->Belt.Array.keep(hgtTEst)
->Belt.Array.keep(regexTest)
->Belt.Array.length
->Js.log
