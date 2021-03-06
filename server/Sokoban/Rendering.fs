module Rendering

open Models
open Game
open System

let renderCell (row, col) cellType =
    Console.CursorLeft <- col
    Console.CursorTop <- row
    printf "%c" (convertFromCellType cellType)

let renderBoard level board =
    printf "Level %d" level
    Console.CursorTop <- 1
    board 
    |> Map.iter renderCell

let render (gameState : GameState) : unit =
    Console.Clear ()
    Console.CursorTop <- 0
    Console.CursorLeft <- 0
    match gameState with
    | NotStarted -> 
        printf "Press Space to Start..."
    | Playing (level, board, _) -> 
        renderBoard level board
    | _ -> printf "Not implemented"