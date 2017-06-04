module BattleshipProbabilityCalculator exposing (..)

import Model exposing(Cell, initialBattleshipGrid)
import Array2D exposing(..)

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
    ({cell | probability =  (checkHorizontalForSize shipSize 1 grid row column)
                          + (checkVerticalForSize shipSize 1 grid row column) })

checkHorizontalForSize : Int -> Int -> Array2D Cell -> Int -> Int -> Int
checkHorizontalForSize shipSize counter grid row column =
    if shipSize == counter then checkHorizontal shipSize grid row column
    else checkHorizontal shipSize grid row column +
        checkHorizontalForSize shipSize (counter + 1) grid (row - 1) column

checkVerticalForSize : Int -> Int -> Array2D Cell -> Int -> Int -> Int
checkVerticalForSize shipSize counter grid row column =
    if shipSize == counter then checkVertical shipSize grid row column
    else checkVertical shipSize grid row column +
        checkVerticalForSize shipSize (counter + 1) grid row (column - 1)

checkHorizontal : Int -> Array2D Cell -> Int -> Int -> Int
checkHorizontal shipSize grid row column =
    let 
        cell = get row column grid
    in 
        case cellIsNotShot cell of 
            True -> 
                if shipSize == 1 then 1
                else checkHorizontal (shipSize - 1) grid (row + 1) column
            False -> 0

checkVertical : Int -> Array2D Cell -> Int -> Int -> Int
checkVertical shipSize grid row column =
    let 
        cell = get row column grid
    in 
        case cellIsNotShot cell of 
            True -> 
                if shipSize == 1 then 1
                else checkVertical (shipSize - 1) grid row (column + 1)
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