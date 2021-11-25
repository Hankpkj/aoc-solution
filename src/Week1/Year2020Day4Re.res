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
let toSingleLine = s => s->Js.String2.replaceByRe(%re("/[\s]+/g"), " ")

type passport = {
  byr: string,
  iyr: string,
  eyr: string,
  hgt: string,
  hcl: string,
  ecl: string,
  pid: string,
  cid: string, // TODO: change meanless string into None
}

let sequence = listOfOptionable =>
  listOfOptionable->List.reduce(Some(list{}), (acc, optionable) =>
    switch (acc, optionable) {
    | (Some(acc), Some(isSomeValue)) => Some(list{isSomeValue, ...acc})
    | _ => None
    }
  )

let intCheck = (target, min, max) => {
  let targetToInt = target->Int.fromString->Option.getExn
  min <= targetToInt && targetToInt <= max ? Some(targetToInt->Int.toString) : None
}

let extractIntAndCheck = (arr, min, max) => arr->Array.getExn(1)->intCheck(min, max)
let extractStr = arr => arr->Array.get(1)

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
  | Cm(height) => height->Int.toString->intCheck(150, 193) //
  | In(height) => height->Int.toString->intCheck(59, 76)
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
      | Cm(i) => Some(i->Int.toString ++ "cm")
      | In(i) => Some(i->Int.toString ++ "in")
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
let apply = s => {
  list{
    Some(s->parseStr(cidRe)->Option.mapWithDefault("no cid", id)), // TODO: change meanless string into None
    s->parseStr(pidRe),
    s->parseStr(eclRe),
    s->parseStr(hclRe),
    s->parseHgt,
    s->parseYear(eyrRe, 2020, 2030),
    s->parseYear(iyrRe, 2010, 2020),
    s->parseYear(byrRe, 1920, 2002),
  }
}

let listToPassport = li => {
  switch li {
  | list{byr, iyr, eyr, hgt, hcl, ecl, pid, cid} =>
    Some({
      byr: byr,
      iyr: iyr,
      eyr: eyr,
      hgt: hgt,
      hcl: hcl,
      ecl: ecl,
      pid: pid,
      cid: cid,
    })
  | _ => None
  }
}

input
->Array.map(toSingleLine)
->List.fromArray
->List.map(apply) // list of list
->List.keepMap(sequence)
->List.toArray
->Array.keepMap(listToPassport)
// ->Array.length
->Js.log
