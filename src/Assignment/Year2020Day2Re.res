open Input
let input = Input.getInput(Input.Single, 2)

open Belt

let li = input->List.fromArray

type policy = {
  low: int,
  high: int,
  target: string,
  source: string,
}

let id = a => a
let split = string => string->Js.String2.splitByRe(%re("/-|\s|:\s/g"))->Array.keepMap(id)

let intStringToInt = s => s->Int.fromString->Option.getExn

let parsing = fullString =>
  switch fullString->split {
  | [a, b, c, d] => Some({low: a->intStringToInt, high: b->intStringToInt, target: c, source: d})
  | _ => None
  }

let judgeX = p => {
  let {low, high, target, source} = p
  let cnt = source->Js.String2.split("")->Array.keep(x => x === target)->Array.length
  cnt >= low && cnt <= high
}

let judgeY = p => {
  let {low, high, target, source} = p
  let sourceToArr = source->Js.String2.split("")
  let lowCharIsTarget = sourceToArr->Array.getExn(low - 1) === target
  let highCharIsTarget = sourceToArr->Array.getExn(high - 1) === target
  lowCharIsTarget !== highCharIsTarget
}

// example 1 answer
li->List.keepMap(parsing)->List.keep(judgeX)->List.size->Js.log

// example 2 answer
li->List.keepMap(parsing)->List.keep(judgeY)->List.size->Js.log
