let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day3.sample.txt")

let fn = (a) => (b) => a + b
let fn2 = fn(3)

input->Js.log

let arr = input->Js.String2.split("\n")->Belt.List.fromArray
let rowLength = arr->Belt.List.head->Belt.Option.mapWithDefault(0, Js.String2.length)

let a = arr
  ->Belt.List.keep(a => a !== "")
  ->Belt.List.map(str => str->Js.String2.split(""))
  ->Belt.List.mapWithIndex((idx, arr) => {
      arr[(idx * 3) - (idx * 3 / rowLength) * rowLength]
  })
  ->Belt.List.keep(x => x === "#")
  ->Belt.List.length

a->Js.log

// input->Js.String2.split("\n")


/*
let arr = input.split("\n");
let rowLength = arr[0].length;

let a = arr.filter(a => !!a)
           .map((str, idx) => str[idx * 3 - parseInt(idx * 3 / rowLength) * rowLength])
           .filter((x) => x === '#').length;
*/        

