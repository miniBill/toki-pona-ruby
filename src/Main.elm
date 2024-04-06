module Main exposing (Model, Msg, main)

import Browser
import Element exposing (Element, column, el, fill, height, padding, paragraph, text, width)
import Element.Input as Input
import Html.String
import Html.String.Attributes


type alias Model =
    String


type Msg
    = Input String


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view =
            \model ->
                Element.layout
                    [ width fill
                    , height fill
                    ]
                    (view model)
        , update = update
        }


init : Model
init =
    "toki pi toki pona"


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Input input ->
            input


view : Model -> Element Msg
view model =
    let
        ruby : Html.String.Html msg
        ruby =
            viewRuby model
    in
    column [ padding 10 ]
        [ Input.text []
            { onChange = Input
            , placeholder = Nothing
            , text = model
            , label = Input.labelAbove [] <| text "Input"
            }
        , el [] <| Element.html <| Html.String.toHtml ruby
        , paragraph []
            [ text <| Html.String.toString 0 ruby
            ]
        ]


viewRuby : Model -> Html.String.Html msg
viewRuby input =
    input
        |> String.split " "
        |> List.concatMap
            (\word ->
                [ Html.String.span [ Html.String.Attributes.style "font-family" "linja pona" ]
                    [ Html.String.text word
                    ]
                , Html.String.rt [] [ Html.String.text <| word ++ " " ]
                ]
            )
        |> Html.String.ruby []
