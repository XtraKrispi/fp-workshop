// Learn more about F# at http://fsharp.org

open System.IO
open System.Threading.Tasks

open Giraffe
open Saturn

open Giraffe.Serialization
open Microsoft.Extensions.DependencyInjection

open Microsoft.AspNetCore.Builder
open VideoGameDbSaturn.Models

let port = 8085us

let getPublishers () = 
    [{id = 1; name = "test"}; {id = 2; name = "test2"}]

let publisherRouter = scope {
    get "/" (json (getPublishers()))
    get "" (json (getPublishers()))
}

let apiRouter = scope {
    forward "/publishers" publisherRouter
}

let webApp = scope {
    forward "/api" apiRouter
}

let configureSerialization (services:IServiceCollection) =
  services.AddSingleton<IJsonSerializer>(NewtonsoftJsonSerializer (Newtonsoft.Json.JsonSerializerSettings()))

let configureApp (app:IApplicationBuilder) =
  app.UseDefaultFiles()

let app = application {
    url ("http://0.0.0.0:" + port.ToString() + "/")
    router webApp
    app_config configureApp
    memory_cache
    service_config configureSerialization
    use_gzip
}

[<EntryPoint>]
let main argv =
    run app
    0 // return an integer exit code
