open System.IO
open System.Threading.Tasks

open Microsoft.AspNetCore.Builder
open Microsoft.Extensions.DependencyInjection
open Giraffe
open Saturn
open Shared

open Giraffe.Serialization
open Db

let publicPath = Path.GetFullPath "../Client/public"
let port = 8085us

let getTodos () : Task<Todo list> = task { 
    return Db.getTodos ()
 }

let saveTodo (todo : Todo) : Task<int> = task {
    return Db.saveTodo todo
}

let todosApi = scope {
    get "" (fun next ctx ->
        task {
            let! todos = getTodos()
            return! Successful.OK todos next ctx
        }
    )
    post "" (fun next ctx ->
        task {
            let! todo = ctx.BindJsonAsync<Todo>()
            let! affectedRows = saveTodo todo
            return! Successful.OK affectedRows next ctx
        })
}

let webApp = scope {    
    forward "/api/todos" todosApi 
}

let configureSerialization (services:IServiceCollection) =
    let fableJsonSettings = Newtonsoft.Json.JsonSerializerSettings()
    fableJsonSettings.Converters.Add(Fable.JsonConverter())
    services.AddSingleton<IJsonSerializer>(NewtonsoftJsonSerializer fableJsonSettings)

let app = application {
    url ("http://0.0.0.0:" + port.ToString() + "/")
    router webApp
    memory_cache
    use_static publicPath
    service_config configureSerialization
    use_gzip
}

run app
