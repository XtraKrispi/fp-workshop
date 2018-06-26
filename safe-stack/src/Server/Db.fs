module Db


open Dapper
open Shared
open System
open System.IO
open System.Data.SQLite

type private RawTodo = {
  todoId : int64
  description : string
  isComplete : int64
}

type private InsertTodoRequest = { description : string; isComplete : int64}

let dbPath = Path.Combine(Environment.CurrentDirectory, "db.sqlite3")
let getConnection () =
  new SQLiteConnection(sprintf "Data Source=%s" dbPath)

let getTodos () = 
   use conn = getConnection ()
   conn.Query<RawTodo>("SELECT TodoId, Description, IsComplete FROM Todo")
   |> Seq.map (fun f -> { todoId = int f.todoId
                          description = f.description
                          isComplete = f.isComplete = int64 1
                        } : Todo)
   |> Seq.toList

let saveTodo (todo : Todo) =
  use conn = getConnection()
  let rawTodo = { todoId = int64 todo.todoId
                  description = todo.description
                  isComplete = if todo.isComplete then int64 1 else int64 0
                }
  if todo.todoId = 0 then
    conn.Execute("""
                  INSERT INTO Todo(Description, IsComplete) 
                  VALUES(@description, @isComplete)
                 """, {description = rawTodo.description; isComplete = rawTodo.isComplete})
  else  
    conn.Execute("""
                  UPDATE Todo 
                  SET Description = @description
                    , IsComplete = @isComplete
                  WHERE TodoId = @todoId
                 """, rawTodo)
  