// let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day7.sample.txt")

// let arr = input->Js.String2.split("\n")
// let containRe = %re("/(.*?)\scontain\s(.*?)(?:$)/")

// let makeValueMap = arr => {
//   switch arr {
//   | [_, num, bag] =>
//     Some(
//       Belt.Map.String.set(
//         Belt.Map.String.empty,
//         bag,
//         num->Belt.Int.fromString->Belt.Option.getUnsafe,
//       ),
//     )
//   | _ => None
//   }
// }

// let makeMap = (key, values) => {
//   let key = key->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/g"), "")
//   let valueMap =
//     values
//     ->Js.String2.replaceByRe(%re("/\s(bags|bag)[\.]*/g"), "")
//     ->Js.String2.split(", ")
//     ->Belt.Array.keepMap(str => {
//       let re = %re("/([0-9]+)\s(.*?)(?:$)/")
//       let splited = str->Js.String2.match_(re)
//       switch splited {
//       | Some(arr) => arr->makeValueMap
//       | _ => None
//       }
//     })
//   (key, valueMap)
// }

// let extract = arr => {
//   switch arr {
//   | [_, k, v] => Some(makeMap(k, v))
//   | _ => None
//   }
// }

// let maps = arr->Belt.Array.keepMap(s => {
//   let matched = s->Js.String2.match_(containRe)
//   switch matched {
//   | Some(arr) => arr->extract
//   | _ => None
//   }
// })

// let getKeyFromMap = m => m->Belt.Map.String.keysToArray->Belt.Array.getExn(0)

// let totalMap = Belt.Map.String.mergeMany(Belt.Map.String.empty, maps)

// // Q1
// let totalArr = totalMap->Belt.Map.String.toArray

// let rec getParents = s => {
//   let parrents =
//     totalArr->Belt.Array.keepMap(((key_, maps)) =>
//       maps->Belt.Array.map(getKeyFromMap)->Belt.Array.keep(t => t === s)->Belt.Array.length !== 0
//         ? Some(key_)
//         : None
//     )
//   let set = parrents->Belt.Set.String.fromArray
//   switch set->Belt.Set.String.size {
//   | 0 => Belt.Set.String.empty
//   | _ => set->Belt.Set.String.reduce(set, (acc, cur) => acc->Belt.Set.String.union(getParents(cur)))
//   }
// }

// getParents("shiny gold")->Belt.Set.String.size->Js.log

// let getKeyValueFromMap = m => {
//   let toArr = m->Belt.Map.String.toArray
//   switch toArr {
//   | [(a_, b_)] => Some(a_, b_)
//   | _ => None
//   }
// }

// let rec getChildWithParent = key => {
//   let children = totalMap->Belt.Map.String.get(key)
//   switch children {
//   | Some(arr) =>
//     arr
//     ->Belt.Array.keepMap(getKeyValueFromMap)
//     ->Belt.Array.map(((k, v)) => getChildWithParent(k) * v + v)
//     ->Belt.Array.reduce(0, (acc, cur) => acc + cur) // 0: 항등원
//   | _ => 0 // no child
//   }
// }

// "shiny gold"->getChildWithParent->Js.log
