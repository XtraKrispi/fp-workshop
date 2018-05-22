// Learn more about F# at http://fsharp.org

open Models
open Game
open Rendering
open System

let rec nextAction () = 
    let key = Console.ReadKey()
    match key.Key with
    | ConsoleKey.UpArrow -> MoveUp
    | ConsoleKey.DownArrow -> MoveDown
    | ConsoleKey.LeftArrow -> MoveLeft
    | ConsoleKey.RightArrow -> MoveRight
    | ConsoleKey.Escape -> QuitGame
    | ConsoleKey.Spacebar -> StartGame
    | _ -> nextAction ()

let rec gameLoop (state : GameState) : unit = 
    render state
    let action = nextAction ()
    let newState = step action state 
    render newState
    match newState with
    | GameOver _ -> ()
    | _ -> gameLoop newState

[<EntryPoint>]
let main _ =
    Console.CursorVisible <- false
    let initialState = initState ()
    gameLoop initialState
    Console.CursorVisible <- true
    0 // return an integer exit code
