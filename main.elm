import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)
import Http exposing (..)

main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }

-- MODEL^

type alias Battleship = 
    { fields: List String }

type alias Model =
    { playerId: String
    , gameId: String
    , url: String
    , battleShips: List Battleship
    }

model : Model
model = 
    Model "" "" "http://localhost:8000" [ Battleship ["A1", "A2"]
                                        , Battleship ["B1", "B2", "B3"]
                                        , Battleship ["C1", "C2", "C3"]
                                        , Battleship ["D1", "D2", "D3", "D4"]
                                        , Battleship ["E1", "E2", "E3", "E4", "E5"]
                                        ]

battleShipRefereeUrl : String
battleShipRefereeUrl =
    "http://localhost:50095/Register"

-- Init
init : (Model, Cmd Msg)
init =
    ( model, Cmd.none )

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- UPDATE

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

jsonEncodeBattleShip : Battleship -> Encode.Value
jsonEncodeBattleShip battleShip =
    Encode.object
    [ ("Fields", battleShip.fields
                    |> List.map (\field -> (Encode.string field))
                    |> Encode.list) ]

registerGameCmd : Model -> String -> Cmd Msg
registerGameCmd model url =
    Http.send HandleResult (registerGame model url)

handleResult : Model -> Result Http.Error String -> (Model, Cmd Msg)
handleResult model result =
    case result of
        Ok resultMessage ->
            ( model |> Debug.log resultMessage, Cmd.none )

        Err error ->
            ( model |> Debug.log (toString error), Cmd.none )

            

type Msg 
    = PlayerId String
    | GameId String
    | RegisterGame
    | HandleResult (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case Debug.log (toString msg) msg of
    PlayerId playerId -> 
    ( { model | playerId = playerId }, Cmd.none )

    GameId gameId ->
    ( { model | gameId = gameId }, Cmd.none )

    RegisterGame ->
    ( model, registerGameCmd model battleShipRefereeUrl)

    HandleResult result ->
        handleResult model result


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Game ID", onInput GameId] []
    , input [ type_ "text", placeholder "Player ID", onInput PlayerId] []
    , button [ onClick RegisterGame][ text "Go!"]
    ]

