namespace Models

type CellType = 
    | Empty
    | Player
    | Wall
    | Box
    | DropPoint

type Position = int * int

type Cell = Position * CellType

type ContinuationStatus = | Continue | Terminate

type GameBoard = Map<Position, CellType>
type InitialGameBoard = GameBoard
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
    | Playing of Level * GameBoard * InitialGameBoard
    | LevelFinished of Level
    | GameOver of Level
    