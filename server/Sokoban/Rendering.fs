module Rendering

open Models
open Game
open System

let renderRow = List.iter (convertFromCell >> printf "%c")

let nextLine () = 
    Console.CursorTop <- Console.CursorTop + 1
    Console.CursorLeft <- 0

let renderBoard level board =
    printf "Level %d" level
    nextLine ()
    board 
    |> List.iter (renderRow >> nextLine)

let render (gameState : GameState) : unit =
    Console.Clear ()
    Console.CursorTop <- 0
    Console.CursorLeft <- 0
    match gameState with
    | NotStarted -> 
        printf "Press Space to Start..."
    | Playing (level, board) -> 
        renderBoard level board
    | _ -> printf "Not implemented"