module Client

open Elmish
open Elmish.React

open Fable.Helpers.React
open Fable.Helpers.React.Props
open Fable.PowerPack.Fetch

open Shared


type Model = Counter option

type Msg =
| Increment
| Decrement
| Init of Result<Counter, exn>

let init () : Model * Cmd<Msg> =
    let model = None
    let cmd =
        Cmd.ofPromise
            (fetchAs<int> "/api/init")
            []
            (Ok >> Init)
            (Error >> Init)
    model, cmd

let update (msg : Msg) (model : Model) : Model * Cmd<Msg> =
    let model' =
        match model,  msg with
        | Some x, Increment -> Some (x + 1)
        | Some x, Decrement -> Some (x - 1)
        | None, Init (Ok x) -> Some x
        | _ -> None
    model', Cmd.none

let safeComponents =
    let intersperse sep ls =
        List.foldBack (fun x -> function
            | [] -> [x]
            | xs -> x::sep::xs) ls []

    let components =
        [
            "Saturn", "https://saturnframework.github.io/docs/"
            "Fable", "http://fable.io"
            "Elmish", "https://elmish.github.io/elmish/"
        ]
        |> List.map (fun (desc,link) -> a [ Href link ] [ str desc ] )
        |> intersperse (str ", ")
        |> span [ ]

    p [ ]
        [ strong [] [ str "SAFE Template" ]
          str " powered by: "
          components ]

let show = function
| Some x -> string x
| None -> "Loading..."

let view (model : Model) (dispatch : Msg -> unit) =
    div [] [ 
        section [ Class "todoapp"] [ 
            header [Class "header"] [
                h1 [] [str "todos"]
                input [Class "new-todo"; Placeholder "What needs to be done?"; AutoFocus true]
            ]
            section [Class "main"] [
                input [Id "toggle-all"; Class "toggle-all"; Type "checkbox"]
                label [ HtmlFor "toggle-all"] [ str "Mark all as complete"]
                ul [ Class "todo-list"] [
                    // These are here just to show the structure of the list items
                    // List items should get the class `editing` when editing and `completed` when marked as completed
                    li [Class "completed"] [
                        div [Class "view"] [
                            input [Class "toggle"; Type "checkbox"; Checked true]
                            label [] [str "Taste Javascript"]
                            button [Class "destroy"] []
                        ]
                        input [Class "edit"; Value "Create a TodoMVC template"]
                    ]
                    li [] [
                        div [Class "view"] [
                            input [Class "toggle"; Type "checkbox"]
                            label [] [str "Buy a unicorn"]
                            button [Class "destroy"] []
                        ]
                        input [Class "edit"; Value "Rule the we"]
                    ]
                ]
            ]
            footer [Class "footer"] [
                span [Class "todo-count"][
                    strong [][str "0"]
                    str " item left"
                ]
                ul [ Class "filters" ] [
                    li [] [ 
                        a [Class "selected"; Href "#/"] [ str "All"]
                    ]
                    li [] [ 
                        a [Href "#/active"] [ str "Active"]
                    ]
                    li [] [ 
                        a [Href "#/completed"] [ str "Completed"]
                    ]
                ]
            ]
        ] 
        footer [ Class "info"] [
            p [] [str "Double-click to edit a todo"]
            p [] [ 
                str "Template by "
                a [Href "http://sindresorhus.com"] [str "Sindre Sorhus"]
            ]
            p [] [str "Created by Goldie"] 
            safeComponents
        ]
    ]

#if DEBUG
open Elmish.Debug
open Elmish.HMR
#endif

Program.mkProgram init update view
#if DEBUG
|> Program.withConsoleTrace
|> Program.withHMR
#endif
|> Program.withReact "elmish-app"
#if DEBUG
|> Program.withDebugger
#endif
|> Program.run
