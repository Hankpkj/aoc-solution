let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day6.sample.txt")

let blankReplaceNewline = (s) => if s === "" {"\n"} else {s}

let splitBy = (s) => s -> Js.String2.split

let list = input -> splitBy("\n")  // TODO : make simple
                 -> Js.Array2.map(blankReplaceNewline) 
                 -> Js.Array2.joinWith("")
                 -> splitBy("\n")
                 -> Belt.List.fromArray

let getCharSetSize = (s) => s -> splitBy("") 
                              -> Belt_SetString.fromArray 
                              -> Belt_SetString.size

let sum = (a, b) => a + b

// 1 answer
list -> Belt.List.map(getCharSetSize) 
     -> Belt.List.reduce(0, sum) 
     -> Js.log

 