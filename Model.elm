module Model exposing (..)

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