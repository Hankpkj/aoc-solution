let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day8.sample.txt")
let arr = input->Js.String2.split("\n")

let length = arr->Belt.Array.length
let val = ref(0)
let currentIdx = ref(0)
let set = ref(Belt.Set.Int.empty)
let toChange = ref(0)

let jump = i =>
  currentIdx.contents === toChange.contents
    ? currentIdx := currentIdx.contents + 1
    : currentIdx := currentIdx.contents + i
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

let whileFtn = () => while (
  currentIdx.contents < length && !(set.contents->Belt.Set.Int.has(currentIdx.contents))
) {
  set := set.contents->Belt.Set.Int.add(currentIdx.contents)
  arr->Belt.Array.getExn(currentIdx.contents)->do
}

// example 1

whileFtn()
val.contents->Js.log

//example 2
let id = t => t

let jumpIdx =
  arr
  ->Belt.Array.mapWithIndex((idx, s) => Js.Re.test_(%re("/^jmp/"), s) ? Some(idx) : None)
  ->Belt.Array.keepMap(id)
  ->Belt.List.fromArray

jumpIdx
->Belt.List.keepMap(toChangeIdx => {
  val := 0
  currentIdx := 0
  set := Belt.Set.Int.empty
  toChange := toChangeIdx
  whileFtn()
  currentIdx.contents === length ? Some(val.contents) : None
})
->Belt.List.headExn
->Js.log