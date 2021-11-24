let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day7.sample.txt")

let arr = input->Js.String2.split("\n")

let id = t => t

let containRe = %re("/(.*?)\scontain\s(.*?)(?:$)/")
let divideRe = %re("/,\s/")
// arr -> Belt.Array.map(tt => tt->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/"), ""))

let makeValueMap = arr => {
  switch arr {
  | [_, num, bag] =>
    Some(
      Belt.Map.String.set(
        Belt.Map.String.empty,
        bag,
        num->Belt.Int.fromString->Belt.Option.getUnsafe,
      ),
    )
  | _ => None
  }
}

let makeMap = (key, values) => {
  // Map<string, Map<string, int>>
  let key = key->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/g"), "")
  let valueMap =
    values
    ->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/g"), "")
    ->Js.String2.split(", ")
    ->Belt.Array.keepMap(str => {
      let re = %re("/([0-9]+)\s(.*?)(?:$)/")
      let splited = str->Js.String2.match_(re)
      switch splited {
      | Some(arr) => arr->makeValueMap
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

let maps = arr->Belt.Array.keepMap(s => {
  let matched = s->Js.String2.match_(containRe)
  switch matched {
  | Some(arr) => arr->extract
  | _ => None
  }
})

let getKeyFromMap = m => m -> Belt.Map.String.keysToArray->Belt.Array.getExn(0)


let getKeyValueFromMap = m => {
  let toArr = m->Belt.Map.String.toArray
  switch toArr {
  | [(a_, b_)] => Some(a_, b_)
  | _ => None
  }
}

let totalMap = Belt.Map.String.mergeMany(Belt.Map.String.empty, maps)
// Map.String.t<string, Array<Map.String.t<string,int>>>

// Q1
let totalArr = totalMap->Belt.Map.String.toArray
let rec getParents = s => {
  let parrents =
    totalArr->Belt.Array.keepMap(((key_, maps)) =>
      maps->Belt.Array.map(getKeyFromMap)->Belt.Array.keep(t => t === s)->Belt.Array.length !== 0
        ? Some(key_)
        : None
    )
  let set = parrents->Belt.Set.String.fromArray
  switch set->Belt.Set.String.size {
  | 0 => Belt.Set.String.empty
  | _ => set->Belt.Set.String.reduce(set, (acc, cur) => acc->Belt.Set.String.union(getParents(cur)))
  }
}

getParents("shiny gold")->Belt.Set.String.size->Js.log


// Q2
let rec getChild = key => {
  let children = totalMap->Belt.Map.String.get(key)
  switch children {
  | Some(arr) =>
    if arr->Belt.Array.length !== 0 {
      arr
      ->Belt.Array.keepMap(getKeyValueFromMap)
      ->Belt.Array.map(((k, v)) => getChild(k) * v)
      ->Belt.Array.reduce(0, (acc, cur) => acc + cur) // 0: 항등원
    } else {
      1
    } // 항등원
  | _ => 1 // 항등원
  }
}

// getChild("shiny gold")->Js.log
