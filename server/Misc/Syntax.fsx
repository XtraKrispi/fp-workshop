
let add (x,y) = x + y

let add1 = add (1,2)

let add2 x y  = x + y

[<Literal>]
let Literal = "Hello there"

type Side = float
type Length = float
type Width = float
type Radius = float

type Shape = | Square of Side
             | Rectangle of Length * Width
             | Circle of Radius


let area shape = 
  match shape with
  | Square side -> side * side
  | Rectangle (length, width) -> length * width
  | Circle radius -> System.Math.PI * (radius ** 2.)

let first l = 
  match l with
  | [] -> None
  | x :: _ -> Some x

let factorial n =
  let rec loop acc n =
    if n <= 0 then
      acc
    else
      loop (acc * n) (n - 1)
  loop 1 n

