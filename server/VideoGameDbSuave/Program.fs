// Learn more about F# at http://fsharp.org

open System

open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.Json
open VideoGameDbSuave.Models

let getPublishers () =
    [|{id = 1; name = "test"}; {id = 2; name = "test2"}|]

let JSON v =
    toJson v
    |> Text.Encoding.UTF8.GetString
    |> OK
    >=> Writers.setMimeType "application/json; charset=utf-8"

let webApp = 
    choose [
        path "/api/publishers" >=> JSON (getPublishers ())
    ]

[<EntryPoint>]
let main argv =
    startWebServer defaultConfig webApp
    0 // return an integer exit code
