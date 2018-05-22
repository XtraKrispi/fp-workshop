module Game

open System.IO
open Models

let convertToCellType (ch : char) : CellType =
    match ch with
    | '#' -> Wall
    | '@' -> Player
    | '$' -> Box
    | '.' -> DropPoint 
    | _   -> Empty

let convertToCell (ch : char) pos : Cell =
    convertToCellType ch, pos

let convertFromCellType (cell : CellType) : char =
    match cell with
    | Wall -> '#'
    | Player -> '@'
    | Box -> '$'
    | DropPoint -> '.'
    | Empty -> ' '

let convertToCells (str : string) (row : int) : Cell [] =
    str
    |> Seq.indexed
    |> Seq.map (fun (i, ch) -> convertToCell ch (row, i))
    |> Seq.toArray

let loadGameBoard (level : Level) : GameBoard =
    let rawData = File.ReadAllLines (Path.Combine("Levels", sprintf "Level%d" level))
    rawData
    |> Array.indexed
    |> Array.collect (fun (row, str) -> convertToCells str row)


let initState () : GameState =
   Playing (1, loadGameBoard 1)

let step (action : Action) (gameState : GameState) = 
    match (action, gameState) with
    | (QuitGame, Playing (level, _)) -> GameOver level
    | _ -> gameState 