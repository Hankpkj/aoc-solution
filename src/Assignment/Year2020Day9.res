let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day9.sample.txt")
open Belt
let id = t => t
let arr = input->Js.String2.split("\n")->Array.keepMap(Int.fromString)
let makeCombination = arr =>
  arr
  ->Array.reduceWithIndex([], (acc, v, i) =>
    acc->Array.concat(arr->Array.slice(~offset=i + 1, ~len=25)->Array.map(w => v + w))
  )
  ->Set.Int.fromArray

let make = (arr, value) => {
  switch (arr->Array.length, value) {
  | (5, Some(v)) => {
      let set = arr->makeCombination
      set->Set.Int.has(v) ? None : Some(v)
    }
  | _ => None
  }
}

arr
->Array.mapWithIndex((idx, _) => arr->Array.slice(~offset=idx, ~len=25)->make(arr[idx + 5]))
->Array.keepMap(id)
->Js.log

// [1, 2, 3, 4, 5, 6, 7, 8]->Array.slice(~offset=5, ~len=5)->Js.log
