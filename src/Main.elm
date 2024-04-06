module Main exposing (Flags, Model, Msg, main)

import Browser
import Element.WithContext as Element exposing (el, fill, height, paragraph, width)
import Element.WithContext.Input as Input
import Html.String
import Html.String.Attributes
import Theme exposing (Context, Element, text)
import Translations


type alias Flags =
    { language : String
    }


type alias Model =
    { context : Context
    , input : String
    }


type Msg
    = Input String


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view =
            \model ->
                Element.layout model.context
                    [ Theme.fontSizes.normal
                    , width fill
                    , height fill
                    ]
                    (view model)
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { context =
            { i18n =
                flags.language
                    |> Translations.languageFromString
                    |> Maybe.withDefault Translations.En
                    |> Translations.init
            }
      , input = "toki pi toki pona"
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( { model | input = input }, Cmd.none )


view : Model -> Element Msg
view model =
    let
        ruby : Html.String.Html msg
        ruby =
            viewRuby model
    in
    Theme.column [ Theme.padding ]
        [ Theme.input []
            { onChange = Input
            , placeholder = Nothing
            , text = model.input
            , label = Input.labelAbove [] <| text Translations.input
            }
        , el [] <| Element.html <| Html.String.toHtml ruby
        , paragraph []
            [ text <| \_ -> Html.String.toString 0 ruby
            ]
        ]


viewRuby : Model -> Html.String.Html msg
viewRuby { input } =
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
