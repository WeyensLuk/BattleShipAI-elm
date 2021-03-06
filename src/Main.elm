import Html exposing (..)
import Model exposing (Model)
import View exposing (view)
import Update exposing (update)
import Msgs exposing (Msg)
import Commands exposing (calculateProbabilityGrid, randomlyPlacedBattleships)

main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }

-- Init
init : (Model, Cmd Msg)
init =
    calculateProbabilityGrid
    ( Model.initialModel randomlyPlacedBattleships, Cmd.none )

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

