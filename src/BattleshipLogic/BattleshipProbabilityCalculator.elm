module BattleshipLogic.BattleshipProbabilityCalculator exposing (..)

import Model exposing(Cell, initialBattleshipGrid)
import Array2D exposing(..)

type Direction = 
    Vertical | Horizontal

type alias ProbabilityCriteria =
    { row: Int
    , column: Int
    , shipSize: Int
    , direction: Direction}

calculateProbabilityGrid : Array2D Cell
calculateProbabilityGrid =
    initialBattleshipGrid.grid 
        |> calculateProbabilityFor aircraftCarrier
        |> calculateProbabilityFor battleship
        |> calculateProbabilityFor submarine
        |> calculateProbabilityFor cruiser
        |> calculateProbabilityFor destroyer

calculateProbabilityFor : Int -> Array2D Cell -> Array2D Cell
calculateProbabilityFor shipSize grid =
    grid
        |> indexedMap (permutationsPerCell shipSize grid)

permutationsPerCell : Int -> Array2D Cell -> Int -> Int -> Cell -> Cell
permutationsPerCell shipSize grid row column cell =
    ({cell | probability =  (checkForShip grid (ProbabilityCriteria row column shipSize Horizontal) 1)
                          + (checkForShip grid (ProbabilityCriteria row column shipSize Vertical) 1) })

checkForShip : Array2D Cell -> ProbabilityCriteria -> Int -> Int
checkForShip grid criteria counter =
    if criteria.shipSize == counter then doesShipFit grid criteria criteria.shipSize
    else doesShipFit grid criteria criteria.shipSize +
        checkForShip grid (decrementCriteriaByDirection criteria) (counter + 1)

decrementCriteriaByDirection : ProbabilityCriteria -> ProbabilityCriteria
decrementCriteriaByDirection criteria = 
    case criteria.direction of
        Horizontal -> { criteria | row = criteria.row - 1 }
        Vertical -> { criteria | column = criteria.column - 1 }

incrementCriteriaByDirection : ProbabilityCriteria -> ProbabilityCriteria
incrementCriteriaByDirection criteria = 
    case criteria.direction of
        Horizontal -> { criteria | row = criteria.row + 1 }
        Vertical -> { criteria | column = criteria.column + 1 }

doesShipFit : Array2D Cell -> ProbabilityCriteria -> Int -> Int
doesShipFit grid criteria counter =
    let 
        cell = get criteria.row criteria.column grid
    in 
        case cellIsNotShot cell of 
            True -> 
                if counter == 1 then 1
                else doesShipFit grid (incrementCriteriaByDirection criteria) (counter - 1)
            False -> 0

cellIsNotShot : Maybe Cell -> Bool
cellIsNotShot cell =
    case cell of
        Nothing -> False
        Just cell ->
            case cell.state of
                Model.NotShot -> True
                _ -> False
        
aircraftCarrier : Int
aircraftCarrier = 5

battleship : Int
battleship = 4

submarine : Int
submarine = 3

cruiser : Int
cruiser = 3

destroyer : Int
destroyer = 2