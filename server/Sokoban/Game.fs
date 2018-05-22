module Game

open System.IO
open Models

let convertToCell (ch : char) : Cell =
    match ch with
    | '#' -> Wall
    | '@' -> Player
    | '$' -> Box
    | '.' -> DropPoint 
    | _   -> Empty

let convertFromCell (cell : Cell) : char =
    match cell with
    | Wall -> '#'
    | Player -> '@'
    | Box -> '$'
    | DropPoint -> '.'
    | Empty -> ' '

let convertToCells (str : string) : Cell list =
    str
    |> Seq.map convertToCell
    |> Seq.toList

let loadGameBoard (level : Level) : GameBoard =
    let rawData = File.ReadAllLines (Path.Combine("Levels", sprintf "Level%d" level))
    rawData
    |> Array.map convertToCells
    |> Array.toList


let initState () : GameState =
   Playing (1, loadGameBoard 1)

let step (action : Action) (gameState : GameState) = 
    match (action, gameState) with
    | (QuitGame, Playing (level, _)) -> GameOver level
    | _ -> gameState 