// --- Given Input --- //
open Input
let input = Input.get(Input.Double, 6)

// --- Generanl Utils --- //
let sum = (a, b) => a + b

open Belt
// --- Get initial set_string --- //
let getSetString = s => s->Js.String2.split("")->Set.String.fromArray

let allAlpha = getSetString("abcdefghijklmnopqrstuvwxyz")
let emptyAlpha = getSetString("")

// --- Set Union | Intersect Function --- //
let getUnion = arr => arr -> Array.reduce(allAlpha, Set.String.union) -> Set.String.size
let getIntersect = arr => arr -> Array.reduce(allAlpha, Set.String.intersect) -> Set.String.size

let parseLine = str => str->Js.String2.split("")->Set.String.fromArray
let parsePhrase = str => str->Js.String2.split("\n")->Array.map(parseLine)

// --- Main Part --- //
let l = input->Array.map(parsePhrase)->List.fromArray

// --- Question 1 : Union --- //
let union = l->List.map(getUnion)->List.reduce(0, sum)
union->Js.log

// --- Question 2 : Intersect --- //
let intersect = l->List.map(getIntersect)->List.reduce(0, sum)
intersect->Js.log
