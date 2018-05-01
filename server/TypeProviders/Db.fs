module Db

open FSharp.Data.Sql


[<Literal>]
let connectionString = 
    "Data Source=" + 
    __SOURCE_DIRECTORY__ + @"/db/vg.db;" + 
    "Version=3;foreign keys=true"

// create a type alias with the connection string and database vendor settings
type Db = SqlDataProvider< 
              ConnectionString = connectionString,
              DatabaseVendor = Common.DatabaseProviderTypes.SQLITE,
              IndividualsAmount = 1000,
              SQLiteLibrary = Common.SQLiteLibrary.SystemDataSQLite,
              UseOptionTypes = true >