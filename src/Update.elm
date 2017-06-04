module Update exposing (..)

import Model exposing (Model)
import Msgs exposing (Msg)
import Commands exposing (handleResult, registerGameCmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case Debug.log (toString msg) msg of
    Msgs.PlayerId playerId -> 
      ( { model | playerId = playerId }, Cmd.none )

    Msgs.GameId gameId ->
      ( { model | gameId = gameId }, Cmd.none )

    Msgs.RegisterGame ->
      ( model, registerGameCmd model)

    Msgs.HandleResult result ->
      handleResult model result