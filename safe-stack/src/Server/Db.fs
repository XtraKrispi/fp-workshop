module Db


open Dapper
open System
open System.IO
open System.Data.SQLite

let dbPath = Path.Combine(Environment.CurrentDirectory, "db.sqlite3")
let getConnection () =
  new SQLiteConnection(dbPath)

