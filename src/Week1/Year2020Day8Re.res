open Input
let arr = Input.get(Input.Single, 8)

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
  | Block(int, int)
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

let rec do = (log, currentIdx, currentValue) => {
  if currentIdx < length {
    let instr = instrArr->Array.getExn(currentIdx)
    let pd = makePendingData(currentIdx, currentValue, log, instr)
    switch pd->action {
    | Success(ni, nv) => do(log->Set.Int.add(currentIdx), ni, nv)
    | Fail(ci, cv) => Block(ci, cv)
    }
  } else {
    Finish(currentIdx, currentValue)
  }
}

// example 1
let exampleOneResult = Set.Int.empty->do(0, 0)
switch exampleOneResult {
| Finish(_, _) => Js.log("Finish!")
| Block(_, v) => v->Js.log
}

// example 2
// let rec findGoldSpot = (i) => {}