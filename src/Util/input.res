module Input = {
  open Belt
  type t = Single | Double

  let getInput = (t, fileNum) => {
    let newLineString = "\n"
    let splitStr = switch t {
    | Single => newLineString
    | Double => newLineString->Js.String2.repeat(2)
    }
    Node.Fs.readFileAsUtf8Sync(
      `input/Year2020Day${fileNum->Int.toString}.sample.txt`,
    )->Js.String2.split(splitStr)
  }
}
