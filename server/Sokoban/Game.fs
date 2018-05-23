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
    pos, convertToCellType ch

let convertFromCellType (cell : CellType) : char =
    match cell with
    | Wall -> '#'
    | Player -> '@'
    | Box -> '$'
    | DropPoint -> '.'
    | Empty -> ' '

let convertToCells (str : string) (row : int) : Cell[] =
    str
    |> Seq.indexed
    |> Seq.map (fun (i, ch) -> convertToCell ch (row, i))
    |> Seq.toArray

let loadGameBoard (level : Level) : GameBoard =
    let rawData = File.ReadAllLines (Path.Combine("Levels", sprintf "Level%d" level))
    rawData
    |> Array.indexed
    |> Array.collect (fun (row, str) -> convertToCells str row)
    |> Array.fold (fun map (pos, cellType) -> Map.add pos cellType map) Map.empty

let getPlayerPosition (gameBoard : GameBoard) : Position option =
    Map.tryPick (fun pos cellType -> if cellType = Player then Some pos else None) gameBoard

let initState () : GameState =
    let initialBoard = loadGameBoard 1
    Playing (1, initialBoard, initialBoard)

let step (action : Action) (gameState : GameState) : GameState * ContinuationStatus = 
    match (action, gameState) with
    | (QuitGame, Playing (level, _, _)) -> GameOver level, Terminate
    | (MoveRight, Playing (level, board, initialBoard)) ->
        match getPlayerPosition board with
        | Some (row, col) ->
            let nextPos = row, col + 1
            let board' = Map.add (row, col) Empty board
            Playing (level, Map.add nextPos Player board', initialBoard), Continue
        | None -> gameState, Continue
    | _ -> gameState, Continue