// --- Given Input --- //
let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day4.sample.txt")

// process => parsing(string => setString) -> judge -> count -> log 

let require = ["byr", "hcl", "pid", "ecl", "iyr", "hgt", "eyr"] -> Belt_SetString.fromArray

let parsing = (s) => s
    ->Js.String2.replaceByRe(%re("/[\s]+/g"), " ") 
    ->Js.String2.splitByRe(%re("/[\s]+/g"))
    ->Belt.Array.map(str => str -> Belt.Option.mapWithDefault("", x => x) -> Js.String2.replaceByRe(%re("/:[\w#]+/"), ""))
    ->Belt.Array.keep(x => x !== "") 
    ->Belt_SetString.fromArray

let judge = (s) => 
    s 
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
