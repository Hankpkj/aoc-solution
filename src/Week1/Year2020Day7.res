let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day7.sample.txt")

let list = input -> Js.String2.split("\n") 
                //  -> Belt.List.fromArray

// given Q : How many bag colors can eventually contain at least one shiny gold bag?
// given input : list{ "faded cyan bags contain 4 faded coral bags, 3 faded yellow bags." , ... }

// parsing -> Map<Map<string, number>> : like tree -> get keyword 'some bag' -> make Array<number> -> reduce 

let id = t => t

let re = %re("/(.*?)contain(.*?)(?:$)/gm")

list 
->Belt.Array.map(s => s -> Js.String2.match_(re))
-> Js.log
