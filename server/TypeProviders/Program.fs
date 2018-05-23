// Learn more about F# at http://fsharp.org

open System

open Json

[<EntryPoint>]
let main argv =   
    getCharacters ()
    |> Array.iter (fun c -> printfn "%s, Gender: %s, Species: %s" c.name c.gender c.species)
    0 // return an integer exit code
