let input = Node.Fs.readFileAsUtf8Sync("input/Week1/Year2020Day7.sample.txt")

let list = input -> Js.String2.split("\n") 
                 -> Belt.List.fromArray

// given Q : How many bag colors can eventually contain at least one shiny gold bag?
// given input : list{ "faded cyan bags contain 4 faded coral bags, 3 faded yellow bags." , ... }

list -> Belt.List.forEach((str) => { // TODO : change forEach into map 
    let [parent, splitted] = str -> Js.String2.split("contain")
    let list{...child} = splitted -> Js.String2.split(", ") -> Belt.List.fromArray -> Js.log
    // child -> Belt.List.map(())

})

