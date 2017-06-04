module View exposing (..)

import Html exposing (div, input, button, text, Html)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Msgs exposing (Msg)

view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Game ID", onInput Msgs.GameId] []
    , input [ type_ "text", placeholder "Player ID", onInput Msgs.PlayerId] []
    , button [ onClick Msgs.RegisterGame][ text "Go!"]
    ]