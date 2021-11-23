let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day7.sample.txt")

let list = input -> Js.String2.split("\n") 
                 -> Belt.List.fromArray

// given Q : How many bag colors can eventually contain at least one shiny gold bag?
// given input : list{ "faded cyan bags contain 4 faded coral bags, 3 faded yellow bags." , ... }

// parsing -> Map<Map<string, number>> : like tree -> get keyword 'some bag' -> make Array<number> -> reduce 

let id = t => t

// module StringCmp = Belt.Id.MakeComparable({
//   type t = string
//   let cmp = (a, b) => Pervasives.compare(a, b)
// })

// let m = Belt.Map.make(~id=module(StringCmp))

// Belt.Map.set(m, "b", ("ke", 1)) -> Js.log

let valueToTuple = (s) => {
    let idx = s ->Js.String2.indexOf(" ")
    (s ->Js.String2.sliceToEnd(~from=idx+1), s ->Js.String2.slice(~from=0, ~to_=idx) ->Belt.Int.fromString ->Belt.Option.mapWithDefault(0, id))  
}

let makeMap = (keyString, valueString) => {
    let key = keyString -> Js.String2.replaceByRe(%re("/ bags/"), "")
    let values = valueString -> Js.String2.replaceByRe(%re("/(?:\sbags\.|\sbag\.|\sbags|\sbag)/g"), "") -> Js.String2.split(", ")
    let tuples = values -> Belt.Array.map(valueToTuple)

    let maps = tuples -> Belt.Array.reduce(Belt.Map.String.empty, (acc, (valueK, valueV)) => {
        acc -> Belt.Map.String.set(valueK, valueV)
    })
    Belt.Map.String.set(Belt.Map.String.empty, key, maps)
    // ::Map<string, Map<string, int>>
}

let parseToMap = (s) => {
    let split = s -> Js.String2.split(" contain ") -> Belt.List.fromArray
    switch split {
    | list{a, b} => makeMap(a, b)
    | _ => makeMap("", "") // to remove
    }   
}

// "faded cyan bags contain 4 faded coral bags, 3 faded yellow bags."

// type t1 = MoreChild(Map<string, int>) | NoMoreChild(Int)
// type t = Map< string, t1 >
// 'A'  
// Map<string, Map<string, int>> | Map< string, int>

// type t2 = T2_1(Map<string, Map<string, int>>) | T2_2(Map< string, int>)

// type t1 = MoreChild(Map<string, int>) | NoMoreChild(Int)
// type t = Map< string, t1 >

// key : string 
// 
// type t = Map<string, Map<string, int>>)
// get :: Map<string, Map<string, int>> -> Map<string, int>
// get2 :: Map<string, int> -> int
// t->get('A')->get('B')

// get :: string -> t1

type a = Belt_MapString

// type t = 
// | MoreChild(Belt.Map.t<string, int>) // TODO : change Map<string, Map<string, int>>
// | NoMoreChild(int) 
// | NoChild

// type t1 = Belt.Map.t<string, t>

// Map<string, Map<string, int>> | Map<string, int>
// same level : + , diffent level : *
// let findChild = (m: , k) => {
//     let children = Belt.Map.String.get(k)
//     switch children {
//     | MoreChild(Map<string, int>) => 
//     | NoMoreChild(int) =>   
//     | NoChild => 
//     }
// }

// list 
// ->Belt.List.map(arr => )
/*
'posh teal bags contain 2 faded coral bags, 3 striped crimson bags, 1 faded red bag.',
  'mirrored chartreuse bags contain 3 clear beige bags, 3 shiny silver bags, 3 bright green bags.',
  'dotted red bags contain 4 light chartreuse bags.',
*/

// 'posh teal bags contain 2 faded coral bags, 3 striped crimson bags, 1 faded red bag.', -> map
"posh teal bags contain 2 faded coral bags, 3 striped crimson bags, 1 faded red bag." -> parseToMap -> Js.log
"dotted red bags contain 4 light chartreuse bags." -> parseToMap -> Js.log