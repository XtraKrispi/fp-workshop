
open System 

let (|Int|_|) str =
  match Int32.TryParse(str) with
  | (true, int) -> Some int
  | _ -> None

let (|Decimal|_|) str =
  match Decimal.TryParse(str) with
  | (true, dec) -> Some dec
  | _ -> None

let (|Bool|_|) str =
  match Boolean.TryParse(str) with
  | (true, bool) -> Some bool
  | _ -> None

let output str = 
  match str with
  | Int a -> printfn "It was an int: %d" a
  | Decimal d -> printfn "It was a decimal: %A" d
  | Bool b -> printfn "It was a boolean: %A" b
  | _ -> printfn "I don't know what this is"

let (|MultOf3|_|) i = if i % 3 = 0 then Some MultOf3 else None
let (|MultOf5|_|) i = if i % 5 = 0 then Some MultOf5 else None

let fizzBuzz i =
  match i with
  | MultOf3 & MultOf5 -> printfn "FizzBuzz"
  | MultOf3 -> printfn "Fizz"
  | MultOf5 -> printfn "Buzz"
  | _ -> printfn "%d" i

[1..20] |> List.iter fizzBuzz