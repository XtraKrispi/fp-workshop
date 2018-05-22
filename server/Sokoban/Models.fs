namespace Models

type CellType = 
    | Empty
    | Player
    | Wall
    | Box
    | DropPoint

type Position = int * int

type Cell = CellType * Position

type GameBoard = Cell []

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
    