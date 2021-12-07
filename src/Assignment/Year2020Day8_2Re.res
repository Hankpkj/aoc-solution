// open Input
// let arr = Input.get(Input.Single, 8)

// open Belt

// type running = Terminate | Loop

// type instruction =
//   | Jmp(int)
//   | Acc(int)
//   | Nop(int)

// let makeInstruction = s =>
//   switch s->Js.String2.split(" ") {
//   | ["jmp", v] => v->Int.fromString->Option.map(t => Jmp(t))
//   | ["acc", v] => v->Int.fromString->Option.map(t => Acc(t))
//   | ["nop", v] => v->Int.fromString->Option.map(t => Nop(t))
//   | _ => None
//   }

// let instructions = arr->Array.keepMap(makeInstruction)->List.fromArray

// type pair = {index: int, value: int}
// let pair = (i, v) => {index: i, value:v}

// type nonEmptyList<'a> = {
//   head: 'a,
//   tail: List.t<'a>,
// }

// let cons = (list: nonEmptyList<'a>, head) => {
//   { head, tail: list{ list.head, ...list.tail} }
// } 

// type record = {logs: nonEmptyList<pair>, passed: running}
// let record = (l, p) => {logs: l, passed: p}

// let emptyRecord = {logs: {head: pair(0, 0), tail: list{}}, passed: Loop}

// let eq = (pr, i) => pr.index === i

// let has = (nonEmptyList, idx) => {
//   nonEmptyList.head.index === idx ||
//   nonEmptyList.tail -> List.has(idx, eq)
// }

// let shift = (nonEmptyList, idx, value) => {
//   let {head, tail} = nonEmptyList
//   {
//     head: pair(idx, value),
//     tail: list{head, ...tail}
//   }
// }

// // Q: 리턴 타입이 무엇이냥
// let unshift = (nonEmptyList) => {
//   let {head, tail} = nonEmptyList
//   switch tail {
//   | list{ h, ...t } => Some({ head: h, tail: t })
//   | list{ h } => None
//   | _ => None
//   }
// }
// // when tail is empty :

// // TODO: params -> (instruction, logs) ;; remove or modify record to logs
// let rec do = (instructions, logs) => {
  
//   let {head, tail} = logs
//   if List.length(instructions) === head.index {
//     {...logs, passed: Terminate}
//   } else if record.logs-> has(head.index) {
//     {...logs, passed: Loop}
//   } else {
//     let nextRecord = {...record, logs: record.logs -> shift(currentIdx, value)}
//     switch instructions->List.getExn(currentIdx) {
//     | Nop(_) => instructions->do(currentIdx + 1, {...record, logs: list{pair(currentIdx+1, )}})
//     | Acc(i) => instructions->do(currentIdx + 1, {...nextRecord, value: nextRecord.value + i})
//     | Jmp(i) => instructions->do(currentIdx + i, nextRecord)
//     }
//   }
// }


// let id = t => t
// let initRecord = instructions->do(0, emptyRecord)
// let startIdx = initRecord.logs->List.get(initRecord.logs -> List.size - 1) -> Option.getWithDefault(0)

// let change = (list, index, value) => list->List.mapWithIndex((idx, v) => idx === index ? value : v)

// let modify = i =>
//   switch instructions->List.getExn(i) {
//   | Nop(v) => Jmp(v)
//   | Jmp(v) => Nop(v)
//   | _ => instructions->List.getExn(i)
//   }

// let rec find = idx => { 
//   let instruction = idx->modify
//   switch instruction {
//   | Acc(_) => find(idx + 1)
//   | Jmp(_) | Nop(_) =>
//     instructions->change(idx, instruction)->do(0, emptyRecord)->(t => switch t.passed {
//     | Terminate => t
//     | Loop => find(idx+1)
//     })
//   }
// }
// // 
// find(startIdx)->Js.log
