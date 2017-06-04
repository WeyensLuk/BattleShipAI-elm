module Commands exposing (..)

import Http exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)
import Model exposing (Model)
import Msgs exposing (Msg)

battleShipRefereeUrl : String
battleShipRefereeUrl =
    "http://localhost:50095/Register"

msgDecoder : Decoder String
msgDecoder =
    Decode.field "stuff" Decode.string

registerGame : Model -> String -> Http.Request String
registerGame model url =
    let
        body =
            model
                |> jsonEncode
                |> Http.jsonBody
    in
        Debug.log (toString body)
        Http.post url body msgDecoder

jsonEncode : Model -> Encode.Value
jsonEncode model = 
    Encode.object
        [ ("PlayerId", Encode.string model.playerId)
        , ("GameId", Encode.string model.gameId)
        , ("BattleShips", model.battleShips 
                            |> List.map (jsonEncodeBattleShip) 
                            |> Encode.list)
        ]

jsonEncodeBattleShip : Model.Battleship -> Encode.Value
jsonEncodeBattleShip battleShip =
    Encode.object
    [ ("Fields", battleShip.fields
                    |> List.map (\field -> (Encode.string field))
                    |> Encode.list) ]

registerGameCmd : Model -> Cmd Msg
registerGameCmd model =
    Http.send Msgs.HandleResult (registerGame model battleShipRefereeUrl)

handleResult : Model -> Result Http.Error String -> (Model, Cmd Msg)
handleResult model result =
    case result of
        Ok resultMessage ->
            ( model |> Debug.log resultMessage, Cmd.none )

        Err error ->
            ( model |> Debug.log (toString error), Cmd.none )
           
