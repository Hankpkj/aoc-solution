let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day8.sample.txt")
let arr = input->Js.String2.split("\n")

let length = arr->Belt.Array.length
let val = ref(0)
let currentIdx = ref(0)
let set = ref(Belt.Set.Int.empty)

let jump = i => currentIdx := currentIdx.contents + i
let acc = i => {
  currentIdx := currentIdx.contents + 1
  val := val.contents + i
}

let do = s => {
  let splited = s->Js.String2.splitAtMost(" ", ~limit=2)
  switch splited {
  | ["jmp", v] => jump(v->Belt.Int.fromString->Belt.Option.getExn)
  | ["acc", v] => acc(v->Belt.Int.fromString->Belt.Option.getExn)
  | ["nop", _] => currentIdx := currentIdx.contents + 1
  | _ => ()
  }
}

// example 1
while currentIdx.contents < length && !(set.contents->Belt.Set.Int.has(currentIdx.contents)) {
  set := set.contents->Belt.Set.Int.add(currentIdx.contents)
  arr->Belt.Array.getExn(currentIdx.contents)->do
}
val.contents->Js.log
