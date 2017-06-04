module BattleshipProbabilityCalculator exposing (..)

import Model exposing(Cell, initialBattleshipGrid)
import Array2D exposing(..)
           
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
        |> indexedMap (permutationsPerCell shipSize)

permutationsPerCell : Int -> Int -> Int -> Cell -> Cell
permutationsPerCell shipSize row column cell =
    cell