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
    , battleShips: List Battleship
    }

model : Model
model = 
    Model "" "" []

-- Init
init : (Model, Cmd Msg)
init =
    ( model, Cmd.none)

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
        Http.post url body msgDecoder

jsonEncode : Model -> Encode.Value
jsonEncode model = 
    Encode.object
        [ ("PlayerId", Encode.string model.playerId)
        , ("GameId", Encode.string model.gameId)
        ]

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
  case msg of
    PlayerId playerId -> 
    ( { model | playerId = playerId }, Cmd.none )

    GameId gameId ->
    ( { model | gameId = gameId }, Cmd.none )

    RegisterGame ->
    ( model, registerGameCmd model "http://localhost:50095/Register")

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

