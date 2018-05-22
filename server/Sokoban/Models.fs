namespace Models

type Cell = 
    | Empty
    | Player
    | Wall
    | Box
    | DropPoint

type GameBoard = (Cell list) list

type Action = 
    | MoveUp 
    | MoveDown
    | MoveLeft
    | MoveRight
    | QuitGame
    | StartGame

type Level = int

type GameState = 
    | NotStarted
    | Playing of Level * GameBoard
    | LevelFinished of Level
    | GameOver of Level
    