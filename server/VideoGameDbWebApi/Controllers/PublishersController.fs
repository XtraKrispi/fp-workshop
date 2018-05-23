namespace VideoGameDbWebApi.Controllers

open Microsoft.AspNetCore.Mvc

open VideoGameDbWebApi.Models

[<Route("api/[controller]")>]
type PublishersController () = 
  inherit Controller()

  [<HttpGet>]
  member this.Get() =
      [{id = 1; name = "test"}
       {id = 2; name = "test2"}]