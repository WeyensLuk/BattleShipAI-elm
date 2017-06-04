module Model exposing (..)

import Array2D exposing (..)

type BattleshipState = Alive | Sunk

type GridState = Hit | Miss | NotShot

type alias Battleship = 
    { fields: List String
    , state: BattleshipState }

type alias Model =
    { playerId: String
    , gameId: String
    , url: String
    , battleShips: List Battleship
    }

type alias Cell = 
    { state: GridState
    , probability: Int}

type alias BattleshipGrid =
    { battleShips: List Battleship
    , grid: Array2D Cell}

initialModel : List Battleship -> Model
initialModel battleShips = 
    Model "" "" "http://localhost:8000" battleShips

initialBattleshipGrid : BattleshipGrid
initialBattleshipGrid = 
    BattleshipGrid [] (repeat 10 10 {state = NotShot, probability = 0})