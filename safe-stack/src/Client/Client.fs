module Client

open Elmish
open Elmish.React

open Fable.Helpers.React
open Fable.Helpers.React.Props
open Fable.PowerPack.Fetch

open Shared


type Model = {
    todos : Todo list
    newTodoDescription : string
}

type Msg =
| TodosFetchSuccess of Todo list
| TodosFetchFail of System.Exception
| NewTodoDescriptionChange of string
| CommitNewTodo
| SaveTodoSuccess of Response
| SaveTodoFail of System.Exception

let mkTodo description = { todoId = 0
                           description = description
                           isComplete = false
                         }

let getTodos () = Cmd.ofPromise (fetchAs "/api/todos") [] TodosFetchSuccess TodosFetchFail

let saveTodo (todo : Todo) = Cmd.ofPromise (fun t -> postRecord "/api/todos" t []) todo SaveTodoSuccess SaveTodoFail

let init () : Model * Cmd<Msg> =
    { todos = []
      newTodoDescription = ""
    }, getTodos ()

let update (msg : Msg) (model : Model) : Model * Cmd<Msg> =
    match msg with
    | TodosFetchSuccess todos -> { model with todos = todos }, Cmd.none
    | TodosFetchFail ex -> 
        printfn "Error: %A" ex 
        model, Cmd.none
    | NewTodoDescriptionChange s ->
        { model with 
            newTodoDescription = s
        }, Cmd.none
    | CommitNewTodo ->
        let todo = mkTodo model.newTodoDescription
        model, saveTodo todo
    | SaveTodoSuccess _ ->
        let todo = mkTodo model.newTodoDescription
        { model with 
            newTodoDescription = ""            
            todos = List.append model.todos [todo]
        }, Cmd.none
    | SaveTodoFail ex ->                
        printfn "Error: %A" ex
        model, Cmd.none 

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

let view (model : Model) (dispatch : Msg -> unit) =
    div [] [ 
        section [ Class "todoapp"] [ 
            header [Class "header"] [
                h1 [] [str "todos"]
                input [ Class "new-todo"
                        Placeholder "What needs to be done?"
                        AutoFocus true
                        OnInput (fun e -> dispatch (NewTodoDescriptionChange e.Value))
                        Value model.newTodoDescription
                        OnKeyUp (fun k -> if k.keyCode = 13. then 
                                                dispatch CommitNewTodo 
                                             else ()
                                   )
                      ]
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
