open Input
let arr = Input.getInput(Input.Single, 8)

open Belt

type running = Terminate | Loop

type instruction =
  | Jmp(int)
  | Acc(int)
  | Nop(int)

let makeInstruction = s =>
  switch s->Js.String2.split(" ") {
  | ["jmp", v] => v->Int.fromString->Option.map(t => Jmp(t))
  | ["acc", v] => v->Int.fromString->Option.map(t => Acc(t))
  | ["nop", v] => v->Int.fromString->Option.map(t => Nop(t))
  | _ => None
  }

let instructions = arr->Array.keepMap(makeInstruction)->List.fromArray

type record = {value: int, logs: list<int>, passed: running}
let record = (v, l, p) => {value: v, logs: l, passed: p}

let emptyRecord = {value: 0, logs: list{}, passed: Loop}

let equal = (a, b) => a === b

let addToSet = li => li->List.add

let rec do = (instructions, currentIdx, record) => {
  if List.length(instructions) === currentIdx {
    {...record, passed: Terminate}
  } else if record.logs->List.has(currentIdx, equal) {
    {...record, passed: Loop}
  } else {
    let nextRecord = {...record, logs: record.logs->addToSet(currentIdx)}
    switch instructions->List.getExn(currentIdx) {
    | Nop(_) => instructions->do(currentIdx + 1, nextRecord)
    | Acc(i) => instructions->do(currentIdx + 1, {...nextRecord, value: nextRecord.value + i})
    | Jmp(i) => instructions->do(currentIdx + i, nextRecord)
    }
  }
}


let id = t => t
let initRecord = instructions->do(0, emptyRecord)
let startIdx = initRecord.logs->List.get(initRecord.logs -> List.size - 1) -> Option.getWithDefault(0)

let change = (list, index, value) => list->List.mapWithIndex((idx, v) => idx === index ? value : v)

let modify = i =>
  switch instructions->List.getExn(i) {
  | Nop(v) => Jmp(v)
  | Jmp(v) => Nop(v)
  | _ => instructions->List.getExn(i)
  }

let rec find = idx => { 
  let instruction = idx->modify
  switch instruction {
  | Acc(_) => find(idx + 1)
  | Jmp(_) | Nop(_) =>
    instructions->change(idx, instruction)->do(0, emptyRecord)->(t => switch t.passed {
    | Terminate => t
    | Loop => find(idx+1)
    })
  }
}

find(startIdx)->Js.log