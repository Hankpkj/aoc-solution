let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day7.sample.txt")

let arr = input -> Js.String2.split("\n") 
                //  -> Belt.List.fromArray

// given Q : How many bag colors can eventually contain at least one shiny gold bag?
// given input : list{ "faded cyan bags contain 4 faded coral bags, 3 faded yellow bags." , ... }

// parsing -> Map<Map<string, number>> : like tree -> get keyword 'some bag' -> make Array<number> -> reduce 

let id = t => t

let containRe = %re("/(.*?)\scontain\s(.*?)(?:$)/")
let divideRe = %re("/,\s/")

// arr -> Belt.Array.map(tt => tt->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/"), ""))

let makeValueMap = (arr) => {
    switch arr {
    | [_, num, bag] => Some(Belt.Map.String.set(Belt.Map.String.empty, bag, num -> Belt.Int.fromString -> Belt.Option.getUnsafe))
    | _ => None
    }
}

let makeMap = (key, values) => {
    // Map<string, Map<string, int>>
    let key = key -> Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/g"), "") 
    let valueMap = values 
    ->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/g"), "") 
    ->Js.String2.split(", ") 
    ->Belt.Array.keepMap(str => {
        let re = %re("/([0-9]+)\s(.*?)(?:$)/")
        let splited = str -> Js.String2.match_(re)
        switch splited {
        | Some(arr) => arr -> makeValueMap
        | _ => None
        }
    })
    // Belt.Map.String.set(Belt.Map.String.empty, key, valueMap)
    (key, valueMap)
    
}

let extract = arr => {
    switch arr {
    | [_, k, v] => Some(makeMap(k, v))
    | _ => None
    }
}

let t = arr 
->Belt.Array.keepMap(s => {
    let matched = s -> Js.String2.match_(containRe)
    switch matched {
    | Some(arr) => arr-> extract
    | _ => None
    }
})

let getKeyValueFromMap = (m) => {
    let toArr = m -> Belt.Map.String.toArray
    switch toArr {
    | [(a_, b_)] => Some(a_, b_)
    | _ => None
    }
}

let rec getChild = (m, key) => {
   let children = m -> Belt.Map.String.get(key) 
   switch children {
   | Some(arr) => if arr -> Belt.Array.length !== 0 {arr -> Belt.Array.keepMap(getKeyValueFromMap) -> Belt.Array.map(((k, v)) => v * getChild(m, k)) -> Belt.Array.reduce(0, (acc, cur) => acc + cur)}
                else {1}
   | _ => 1
   }
}

let totalMap = Belt.Map.String.mergeMany(Belt.Map.String.empty, t) 
-> getChild("shiny gold") -> Js.log

/*
  [ 'drab aqua', 2 ],
  [ 'clear black', 1 ],
  [ 'mirrored teal', 5 ],
  [ 'dark chartreuse', 3 ]

  12
*/


