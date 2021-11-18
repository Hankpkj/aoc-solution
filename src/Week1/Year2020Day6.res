// --- Given Input --- //
let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day6.sample.txt")

// --- Generanl Utils --- //
let sum = (a, b) => a + b

// --- Get initial set_string --- //
let splitBy = (s) => s -> Js.String2.split
let getSetString = (s) => s -> splitBy("") -> Belt_SetString.fromArray

let allAlpha = getSetString("abcdefghijklmnopqrstuvwxyz")
let emptyAlpha = getSetString("")

// --- Set Union | Intersect Function --- //
let reduceSkeleton = (arr, init, f) => Belt.Array.reduce(arr, init, f) -> Belt_SetString.size

let getUnion = (arr) => reduceSkeleton(arr, emptyAlpha, Belt_SetString.union)
let getIntersect = (arr) => reduceSkeleton(arr, allAlpha, Belt_SetString.intersect)



/*
adekjfklj
zlkxjlkjsdklfj
woieuroiweu

sdlkhrhjkahdsf
jksherjkh
*/
let parseLine = str => str-> Js.String2.split("") -> Belt.Set.String.fromArray
let parsePhrase = str => str
                ->Js.String2.split("\n") 
                -> Belt.Array.map(parseLine)

// --- Main Part --- //
let l = input
    ->splitBy("\n" ++ "\n") 
    ->Belt.Array.map(parsePhrase) 
    ->Belt.List.fromArray 

// --- Question 1 : Union --- //
let union = l -> Belt.List.map(getUnion) -> Belt.List.reduce(0, sum)
union -> Js.log

// --- Question 2 : Intersect --- //
let intersect = l -> Belt.List.map(getIntersect) -> Belt.List.reduce(0, sum)
intersect -> Js.log