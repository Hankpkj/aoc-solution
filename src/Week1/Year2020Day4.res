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

type passport = {
    byr: int,
    iyr: int,
    eyr: int,
    hgt: string,
    hcl: string,
    ecl: string,
    pid: string,
    cid: option<string> 
}

let toSingleLine = (s) => s ->Js.String2.replaceByRe(%re("/[\s]+/g"), " ")

let intCheck = (target, min, max) => 
    switch target {
    | Some(x_) => min <= x_ && x_ <= max ? Some(x_) : None
    | _ => None
    }

let extractIntAndCheck = (arr, min, max) => 
    switch arr {
    | [_, value] => value -> Belt.Int.fromString -> intCheck(min, max)
    | _ => None
    }

let extractStr = (arr) => 
    switch arr {
    | [_, value] => Some(value)
    | _ => None
    }


let byrRe = %re("/byr:(.*?){4}(?:\s|$)/")
let iyrRe = %re("/iyr:(.*?){4}(?:\s|$)/")
let eyrRe = %re("/eyr:(.*?){4}(?:\s|$)/")
let hgtRe = %re("/hgt:([0-9]{2,3})(in|cm)(?:\s|$)/")
let hclRe = %re("/hcl:(#[a-f0-9]{6})(?:\s|$)/")
let eclRe = %re("/ecl:(amb|blu|brn|gry|grn|hzl|oth)(?:\s|$)/")
let pidRe = %re("/pid:([0-9]{9})/")
let cidRe = %re("/cid:(.*?)(?:\s|$)/")

let parseYear = (s, re, minY, maxY) => {
    let matched = s -> Js.String2.match_(re)
    switch matched {
    | Some(arr) => arr -> extractIntAndCheck(minY, maxY)
    | _ => None
    }
}

let checkHgt = (h, s) => {
    let min = s === "cm" ? 150 : 59
    let max = s === "cm" ? 193 : 76
    let checked = h -> Belt.Int.fromString -> intCheck(min, max)
    switch checked {
        | Some(_) => Some(h ++ s)
        | _ => None
        }
}

let extractHgt = (arr) => 
    switch arr {
    | [_, height, sign] => checkHgt(height, sign)
    | _ => None
    }

let parseStr = (s, re) => {
    let matched = s -> Js.String2.match_(re)
    switch matched {
    | Some(arr) => arr -> extractStr
    | _ => None
    }
}

let parseHgt = (s) => {
    let matched = s -> Js.String2.match_(hgtRe)
    switch matched {
    | Some(arr) => arr -> extractHgt
    | _ => None
    }
}

// process 1
input 
->Js.String2.split("\n\n")
->Belt.Array.map(toSingleLine)
->Belt.Array.keepMap(str => {    
    str ->parseYear(byrRe, 1920, 2002) -> Belt.Option.flatMap(byr => 
        str ->parseYear(iyrRe, 2010, 2020) -> Belt.Option.flatMap(iyr => 
            str ->parseYear(eyrRe, 2020, 2030) -> Belt.Option.flatMap(eyr => 
                str ->parseHgt -> Belt.Option.flatMap(hgt => 
                    str ->parseStr(hclRe)-> Belt.Option.flatMap(hcl => 
                        str ->parseStr(eclRe)-> Belt.Option.flatMap(ecl => 
                            str ->parseStr(pidRe)-> Belt.Option.map(pid => 
                                {
                                    byr: byr,
                                    iyr: iyr,
                                    eyr: eyr,
                                    hgt: hgt,
                                    hcl: hcl,
                                    ecl: ecl,
                                    pid: pid,
                                    cid: str -> parseStr(cidRe)
                                }
                            )
                        )
                    )
                )
            )
        )
    )
})
-> Belt.Array.length
-> Js.log

// process 2

let parseFnList = t => (
    t -> parseYear(byrRe, 1920, 2002), 
    t -> parseYear(iyrRe, 2010, 2020),
    t -> parseYear(eyrRe, 2020, 2030),
    t -> parseHgt,
    t -> parseStr(hclRe),
    t -> parseStr(eclRe),
    t -> parseStr(pidRe),
    t -> parseStr(cidRe)
)

let make = (byr, iyr, eyr, hgt, hcl, ecl, pid, cid) => Some({
    byr: byr, iyr: iyr, eyr: eyr, hgt: hgt, hcl: hcl, ecl: ecl, pid: pid, cid: cid
})

let parse = s => 
    switch parseFnList(s) {
    | (Some(byr), Some(iyr), Some(eyr), Some(hgt), Some(hcl), Some(ecl), Some(pid), cid) => make(byr, iyr, eyr, hgt, hcl, ecl, pid, cid)
    | _ => None
    }

input
->Js.String2.split("\n\n")
->Belt.Array.map(toSingleLine)
->Belt.Array.keepMap(parse)
->Belt.Array.length 
->Js.log

