module Input = {
  open Belt
  type outputType = Single | Double

  let get = (t, fileNum) =>
    switch t {
    | Single =>
      Node.Fs.readFileAsUtf8Sync(`input/Year2020Day${fileNum -> Int.toString}.sample.txt`)->Js.String2.split(
        "\n",
      )
    | Double =>
      Node.Fs.readFileAsUtf8Sync(`input/Year2020Day${fileNum -> Int.toString}.sample.txt`)->Js.String2.split(
        "\n\n",
      )
    }
}
