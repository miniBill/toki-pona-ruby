module Theme exposing (Attribute, Context, Element, column, fontSizes, input, padding, text)

import Element.WithContext as Element
import Element.WithContext.Font as Font
import Element.WithContext.Input as Input
import Translations exposing (I18n)


type alias Context =
    { i18n : I18n }


type alias Element msg =
    Element.Element Context msg


type alias Attribute msg =
    Element.Attribute Context msg


fontSizes :
    { normal : Attribute msg
    }
fontSizes =
    let
        modular : Int -> Attribute msg
        modular n =
            Font.size <| round <| Element.modular 20 1.25 n
    in
    { normal = modular 0
    }


sizes :
    { borderWidth : number1
    , roundness : number2
    , rythm : number3
    }
sizes =
    { borderWidth = 1
    , roundness = 3
    , rythm = 10
    }


spacing : Attribute msg
spacing =
    Element.spacing sizes.rythm


padding : Attribute msg
padding =
    Element.padding sizes.rythm


column : List (Attribute msg) -> List (Element msg) -> Element msg
column attrs =
    Element.column (spacing :: attrs)


text : (I18n -> String) -> Element msg
text f =
    Element.withContext <| \{ i18n } -> Element.text <| f i18n


input :
    List (Attribute msg)
    ->
        { onChange : String -> msg
        , placeholder : Maybe (Input.Placeholder Context msg)
        , text : String
        , label : Input.Label Context msg
        }
    -> Element msg
input attrs config =
    Input.text attrs config
