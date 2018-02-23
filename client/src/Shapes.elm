module Shapes exposing (main)

import Html
    exposing
        ( Html
        , beginnerProgram
        , div
        , label
        , input
        , text
        , span
        )
import Html.Attributes exposing (type_, name, checked, value, id, class)
import Html.Events exposing (onCheck, onInput)


type Msg
    = SquareChecked
    | RectangleChecked
    | SquareSideChanged String
    | RectangleLengthChanged String
    | RectangleWidthChanged String


type Shape
    = Square (FormField Side)
    | Rectangle (FormField Length) (FormField Width)


type Side
    = Side Int


type alias FormField a =
    ( a, String )


type Length
    = Length Int


type Width
    = Width Int


type alias Model =
    Shape


main : Program Never Model Msg
main =
    beginnerProgram { model = model, update = update, view = view }


model : Model
model =
    Rectangle ( (Length 0), "" ) ( (Width 0), "" )


update : Msg -> Model -> Model
update msg model =
    let
        def =
            Result.withDefault 0 << String.toInt
    in
        case msg of
            SquareChecked ->
                Square ( (Side 0), "" )

            RectangleChecked ->
                Rectangle ( (Length 0), "" ) ( (Width 0), "" )

            SquareSideChanged str ->
                case model of
                    Square ( s, _ ) ->
                        case String.toInt str of
                            Ok newSide ->
                                Square ( Side newSide, str )

                            Err _ ->
                                Square ( s, str )

                    _ ->
                        model

            RectangleLengthChanged str ->
                case model of
                    Rectangle ( l, _ ) w ->
                        case String.toInt str of
                            Ok newLength ->
                                Rectangle ( Length newLength, str ) w

                            Err _ ->
                                Rectangle ( l, str ) (w)

                    _ ->
                        model

            RectangleWidthChanged str ->
                case model of
                    Rectangle l ( w, _ ) ->
                        case String.toInt str of
                            Ok newWidth ->
                                Rectangle l ( Width newWidth, str )

                            Err _ ->
                                Rectangle l ( w, str )

                    _ ->
                        model


area : Shape -> Int
area shape =
    case shape of
        Square ( Side s, _ ) ->
            s * s

        Rectangle ( Length l, _ ) ( Width w, _ ) ->
            l * w


view : Model -> Html Msg
view model =
    let
        numberInput l val msg =
            div []
                [ label [] [ text l ]
                , input [ type_ "number", value val, onInput msg ] []
                ]

        shapeView =
            case model of
                Square ( Side side, str ) ->
                    div []
                        [ numberInput "Side Length: " str SquareSideChanged
                        ]

                Rectangle ( Length l, lStr ) ( Width w, wStr ) ->
                    div []
                        [ numberInput "Length: " lStr RectangleLengthChanged
                        , numberInput "Width: " wStr RectangleWidthChanged
                        ]

        isChecked shape1 =
            case ( shape1, model ) of
                ( Square _, Square _ ) ->
                    True

                ( Rectangle _ _, Rectangle _ _ ) ->
                    True

                ( Square _, _ ) ->
                    False

                ( Rectangle _ _, _ ) ->
                    False

        radio n l ic msg =
            label [ class "container" ]
                [ text l
                , input
                    [ type_ "radio"
                    , name n
                    , checked ic
                    , onCheck msg
                    ]
                    []
                , span [ class "checkmark" ] []
                ]

        shapesRadio =
            radio "shapes"
    in
        div [ id "shapes-app" ]
            [ div []
                [ shapesRadio "Square" (isChecked (Square ( (Side 0), "" ))) (always SquareChecked)
                , shapesRadio "Rectangle" (isChecked (Rectangle ( (Length 0), "" ) ( (Width 0), "" ))) (always RectangleChecked)
                ]
            , shapeView
            , div []
                [ span []
                    [ text ("Area: " ++ (toString <| area model))
                    ]
                ]
            ]
