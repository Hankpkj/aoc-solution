open Input
let arr = Input.get(Input.Single, 8)

open Belt

type instruction =
  | Jmp(int)
  | Acc(int)
  | Nop

type pair = {
  index: int,
  value: int,
}
let pair = (i, v) => {index: i, value: v}

type pendingData = {
  instruction: instruction,
  current: pair,
  prev: pair,
  setFromPrev: Set.Int.t,
  prevJmp: pair,
}
let pendingData = (i, cPair, nPair, set, prevJmp) => {
  instruction: i,
  current: cPair,
  prev: nPair,
  setFromPrev: set,
  prevJmp: prevJmp,
}

type excuteType =
  | Success(pendingData)
  | Fail(pair)

type endType =
  | Pass(pair) // value
  | NonPass(pair)

let makeInstruction = s =>
  switch s->Js.String2.split(" ") {
  | ["jmp", v] => v->Int.fromString->Option.map(t => Jmp(t))
  | ["acc", v] => v->Int.fromString->Option.map(t => Acc(t))
  | ["nop", _] => Some(Nop)
  | _ => None
  }

let instructions = arr->Array.keepMap(makeInstruction)
let length = instructions->Array.length

let add = set => set->Set.Int.add
let addSetFromPending = p => {...p, setFromPrev: p.setFromPrev->add(p.current.index)}
let judge = p => p.setFromPrev->Set.Int.has(p.current.index) ? Fail(p.prevJmp) : Success(p->addSetFromPending)

let jump = (p, v) => pendingData(p.instruction, pair(p.current.index + v, p.current.value), p.current, p.setFromPrev, p.current)
let acc = (p, v) => pendingData(p.instruction, pair(p.current.index + 1, p.current.value + v), p.current, p.setFromPrev, p.prevJmp)
let nop = p => {...p, current: pair(p.current.index + 1, p.current.value)}

let nextPendingData = p => 
  switch p.instruction {
  | Jmp(v) => p -> jump(v)
  | Acc(v) => p -> acc(v) 
  | Nop => p -> nop 
}

let rec do = p =>
  p.current.index < length
    ? {
        p -> Js.log
        let cInstr = p.current.index === p.prevJmp.index ? Nop : instructions->Array.getExn(p.current.index)
        switch nextPendingData({...p, instruction: cInstr})->judge {
        | Success(pd) => pd -> do
        // | Fail(pair) => do({...p, current: pair})
        | Fail(pair) => NonPass(pair)
        }
      }
    : Pass(p.current)

let initPair = {index: 0, value: 0}
let initSet = Set.Int.empty
let initInstr = instructions->Array.getExn(0)

let initPendingData = pendingData(initInstr, initPair, initPair, initSet, pair(-1, 0))

initPendingData -> do -> Js.log