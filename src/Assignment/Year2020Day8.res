open Input
let arr = Input.get(Input.Single, 8)
let id = t => t
open Belt
type instruction =
  | Jmp(int)
  | Acc(int)
  | Nop

type pendingData = {
  currentIdx: int,
  currentValue: int,
  idxLog: Set.Int.t,
  instr: instruction,

}

type resultData = Result(int, int) // idx, val

type resultDataType =
  | Success(int, int) //
  | Fail(int, int)

type endTrigger =
  | Block(int, int, int, Set.Int.t) 
  | Finish(int, int)

let toInstruction = s =>
  switch s->Js.String2.splitAtMost(" ", ~limit=2) {
  | ["jmp", v] => Some(Jmp(v->Int.fromString->Option.getExn))
  | ["acc", v] => Some(Acc(v->Int.fromString->Option.getExn))
  | ["nop", _] => Some(Nop)
  | _ => None
  }

let judge = (res, log, ci, cv) => {
  let Result(ni, nv) = res
  log->Set.Int.has(ni) ? Fail(ci, cv) : Success(ni, nv)
}

let action = p => {
  let {currentIdx, currentValue, idxLog, instr} = p
  switch instr {
  | Jmp(addIdx) => Result(currentIdx + addIdx, currentValue)
  | Acc(addVal) => Result(currentIdx + 1, currentValue + addVal)
  | Nop => Result(currentIdx + 1, currentValue)
  }->judge(idxLog, currentIdx, currentValue)
}

let instrArr = arr->Array.keepMap(toInstruction)

let makePendingData = (ci, cv, l, instr) => {
  currentIdx: ci,
  currentValue: cv,
  idxLog: l,
  instr: instr,
}

let length = instrArr->Array.length

let rec do = (log, currentIdx, currentValue, noBlockIdx) => {
  if currentIdx < length {
    let instr = currentIdx === noBlockIdx ? Nop :  instrArr->Array.getExn(currentIdx)
    let pd = makePendingData(currentIdx, currentValue, log, instr)
    switch pd->action {
    | Success(ni, nv) => do(log->Set.Int.add(currentIdx), ni, nv, noBlockIdx)
    | Fail(ci, cv) => Block(ci, cv, noBlockIdx, log)
    }
  } else {
    Finish(currentIdx, currentValue)
  }
}

// example 1
let exampleOneResult = Set.Int.empty->do(0, 0, length)
switch exampleOneResult {
| Finish(_, _) => Js.log("Finish!")
| Block(_, v, _, _) => v->Js.log
}

// example 2

// method 1 : sequential search
let jumpIdx =
  arr
  ->Belt.Array.mapWithIndex((idx, s) => Js.Re.test_(%re("/^jmp/"), s) ? Some(idx) : None)
  ->Belt.Array.keepMap(id)
  ->Belt.List.fromArray

let keepFinish = (t) => switch t {
| Finish(_, v) => Some(v)
| Block(_) => None
}

jumpIdx -> List.keepMap(idx => Set.Int.empty -> do(0, 0, idx) -> keepFinish) -> List.headExn -> Js.log