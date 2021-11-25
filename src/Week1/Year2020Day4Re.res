open Input
let input = Input.get(Input.double, 4)

open Belt
let require = ["byr", "hcl", "pid", "ecl", "iyr", "hgt", "eyr"]->Set.String.fromArray

// ---- example 1 ---- //
let id = t => t
let parsing = s =>
  s
  ->Js.String2.replaceByRe(%re("/[\s]+/g"), " ") // make single line
  ->Js.String2.splitByRe(%re("/[\s]+/g")) // split each item
  ->Array.keepMap(id)
  ->Array.map(str => str->Js.String2.replaceByRe(%re("/:[\w#]+/"), ""))
  ->Set.String.fromArray // to set_string

let judge = s => s->Set.String.intersect(require)->Set.String.size === 7

input->List.fromArray->List.map(parsing)->List.keep(judge)->List.size->Js.log

// ---- example 2 ---- //
type passport = {
  byr: int,
  iyr: int,
  eyr: int,
  hgt: int,
  hcl: string,
  ecl: string,
  pid: string,
  cid: option<string>,
}

let toSingleLine = s => s->Js.String2.replaceByRe(%re("/[\s]+/g"), " ")

let intCheck = (target, min, max) => min <= target && target <= max ? Some(target) : None

let extractIntAndCheck = (arr, min, max) =>
  switch arr {
  | [_, value] => value->Int.fromString->Option.mapWithDefault(0, id)->intCheck(min, max)
  | _ => None
  }

let extractStr = arr =>
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
  let matched = s->Js.String2.match_(re)
  switch matched {
  | Some(arr) => arr->extractIntAndCheck(minY, maxY)
  | _ => None
  }
}

type parsedHgt =
  | Cm(int)
  | In(int)
  | Bad

let checkHgt = h => {
  switch h {
  | Cm(height) => intCheck(height, 150, 192)
  | In(height) => intCheck(height, 59, 76)
  | Bad => None
  }
}

let extractHgt = arr =>
  switch arr {
  | [_, height, sign] => {
      let toInt = height->Int.fromString->Option.mapWithDefault(0, id)
      sign === "cm" ? Cm(toInt) : In(toInt)
    }
  | _ => Bad
  }

let parseHgt = s => {
  let matched = s->Js.String2.match_(hgtRe)
  switch matched {
  | Some(arr) => {
      let hgt = arr->extractHgt
      switch hgt {
      | Cm(i) => Some(i)
      | In(i) => Some(i)
      | Bad => None
      }
    }
  | _ => None
  }
}

let parseStr = (s, re) => {
  let matched = s->Js.String2.match_(re)
  switch matched {
  | Some(arr) => arr->extractStr
  | _ => None
  }
}



// process 1
input
->Array.map(toSingleLine)
->Array.keepMap(str => {
  str
  ->parseYear(byrRe, 1920, 2002)
  ->Option.flatMap(byr =>
    str
    ->parseYear(iyrRe, 2010, 2020)
    ->Option.flatMap(iyr =>
      str
      ->parseYear(eyrRe, 2020, 2030)
      ->Option.flatMap(eyr =>
        str
        ->parseHgt
        ->Option.flatMap(hgt =>
          str
          ->parseStr(hclRe)
          ->Option.flatMap(hcl =>
            str
            ->parseStr(eclRe)
            ->Option.flatMap(ecl =>
              str
              ->parseStr(pidRe)
              ->Option.map(pid => {
                byr: byr,
                iyr: iyr,
                eyr: eyr,
                hgt: hgt,
                hcl: hcl,
                ecl: ecl,
                pid: pid,
                cid: str->parseStr(cidRe),
              })
            )
          )
        )
      )
    )
  )
})
->Array.length
->Js.log

// process 2

let parseFnList = t => (
  t->parseYear(byrRe, 1920, 2002),
  t->parseYear(iyrRe, 2010, 2020),
  t->parseYear(eyrRe, 2020, 2030),
  t->parseHgt,
  t->parseStr(hclRe),
  t->parseStr(eclRe),
  t->parseStr(pidRe),
  t->parseStr(cidRe),
)

let make = (byr, iyr, eyr, hgt, hcl, ecl, pid, cid) => Some({
  byr: byr,
  iyr: iyr,
  eyr: eyr,
  hgt: hgt,
  hcl: hcl,
  ecl: ecl,
  pid: pid,
  cid: cid,
})

let parse = s =>
  switch parseFnList(s) {
  | (Some(byr), Some(iyr), Some(eyr), Some(hgt), Some(hcl), Some(ecl), Some(pid), cid) =>
    make(byr, iyr, eyr, hgt, hcl, ecl, pid, cid)
  | _ => None
  }

input->Array.map(toSingleLine)->Array.keepMap(parse)->Array.length->Js.log
