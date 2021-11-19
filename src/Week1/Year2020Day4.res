// --- Given Input --- //
let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day4.sample.txt")

// process => parsing(string => setString) -> judge -> count -> log 

let require = ["byr", "hcl", "pid", "ecl", "iyr", "hgt", "eyr"] -> Belt_SetString.fromArray

// Q 1
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

/*
byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
*/

let nJudge = (s, min, max) => {
    let n = s ->Belt.Int.fromString ->Belt.Option.mapWithDefault(0, x => x)
    (n >= min) && (n <= max)
}

let makeJudgeFtn = (s) => switch s {
| "byr" => (n) => n -> nJudge(1920, 2002)
| "iyr" => (n) => n -> nJudge(2010, 2020)
| "eyr" => (n) => n -> nJudge(2020, 2030)
| "hgt" => (n) => 
    if Js.Re.test_(%re("/^[0-9]+[in]{2}$/"), n) { nJudge(n, 59, 76) } else {
        if Js.Re.test_(%re("/^[0-9]+[cm]{2}$/"), n) { nJudge(n, 150, 193) } else { false }
    }
| "hcl" => (n) => Js.Re.test_(%re("/^#[a-f0-9]{6}$/"), n)
| "ecl" => (n) => Js.Re.test_(%re("/^[amb|blu|brn|gry|grn|hzl|oth]{3}$/"), n)
| "pid" => (n) => Js.Re.test_(%re("/^[0-9]{9}/"), n)
| "cid" => (_) => false
| _ => (_) => true
}

let parsing2 = (s) => s
    ->Js.String2.replaceByRe(%re("/[\s]+/g"), " ")  // make single line
    ->Js.String2.splitByRe(%re("/[\s]+/g"))        // split each item 
    ->Belt.Array.map(str => {
        str 
        ->Belt.Option.mapWithDefault("", x => x)
        ->Js.String2.split(":")
    }) 

input 
->Js.String2.split("\n"++"\n") 
->Belt.List.fromArray
->Belt.List.map(parsing2)
->Belt.List.map(arr => arr 
    ->Belt.Array.keep(splited => {
        switch splited {
        | [key, value] => makeJudgeFtn(key, value)
        | _ => false
        }
    })
)
->Belt.List.map(arr => arr 
    ->Belt.Array.map(splited => splited 
                                ->Belt.List.fromArray 
                                ->Belt.List.head 
                                ->Belt.Option.mapWithDefault("", x => x))
    ->Belt_SetString.fromArray 
    ->Belt_SetString.intersect(require))
->Belt.List.keep(set => set -> Belt_SetString.size === 7)
->Belt.List.toArray 
->Belt.Array.length 
->Js.log

