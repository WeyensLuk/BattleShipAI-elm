module BattleshipLogic.RandomBattleshipPlacer exposing (..)

import Model exposing (Battleship, BattleshipState)
import BattleshipLogic.BattleshipTypes exposing(..)
import BattleshipLogic.Direction as Direction exposing(..)
import Random exposing (..)

type alias RandomSeed = 
    { seed: Seed }

randomSeed : RandomSeed
randomSeed =
    RandomSeed (Random.initialSeed 42)

getRandomlyPlacedBattleships : List Battleship
getRandomlyPlacedBattleships = 
    getRandomPositionFor destroyer
        :: getRandomPositionFor submarine
        :: getRandomPositionFor cruiser
        :: getRandomPositionFor battleship
        :: getRandomPositionFor aircraftCarrier
        :: []

getRandomValue : Generator a -> a
getRandomValue generator = 
    let
        result = Random.step generator randomSeed.seed
    in
        Tuple.second ({randomSeed | seed = (Tuple.second result)}, Tuple.first result)

getRandomPositionFor : Int -> Battleship
getRandomPositionFor shipSize =
    let
        coordinates = 
            case getRandomValue Random.bool of
                True -> placeShip shipSize (createStartPositionForHorizontalPlacement shipSize) Direction.Horizontal
                False -> placeShip shipSize (createStartPositionForVerticalPlacement shipSize) Direction.Vertical
    in
        Battleship (createFieldsFromStartPosition coordinates) Model.Alive

placeShip : Int -> (Int, Int) -> Direction.Direction -> List (Int, Int)
placeShip shipSize startPos direction =
    case direction of
        Direction.Horizontal -> range startPos (Tuple.first startPos, (Tuple.second startPos) + shipSize - 1)
        Direction.Vertical -> range startPos ((Tuple.first startPos) + shipSize - 1, Tuple.second startPos)

range : (Int, Int) -> (Int, Int) -> List (Int, Int)
range start end = 
    if start == end then [end]
    else
        if (start < end) then
            start :: range (Tuple.first start, (Tuple.second start) + 1)  end
        else
            start :: range (Tuple.first start, (Tuple.second start) - 1)  end


createFieldsFromStartPosition : List (Int, Int) -> List String
createFieldsFromStartPosition coordinates =
    coordinates
        |> List.map (\coordinate -> convertToLetter (Tuple.first coordinate) ++ toString (Tuple.second coordinate))

convertToLetter : Int -> String
convertToLetter number =
    case number of
        1 -> "A"
        2 -> "B"
        3 -> "C"
        4 -> "D"
        5 -> "E"
        6 -> "F"
        7 -> "G"
        8 -> "H"
        9 -> "I"
        10 -> "J"
        _ -> "Z"

createStartPositionForHorizontalPlacement : Int -> (Int, Int)
createStartPositionForHorizontalPlacement shipSize = 
    let 
        generator = pair (int 1 (10 - shipSize + 1)) (int 1 10)
    in
        getRandomValue generator

createStartPositionForVerticalPlacement : Int -> (Int, Int)
createStartPositionForVerticalPlacement shipSize = 
    let
        generator = pair (int 1 10) (int 1 (10 - shipSize + 1))
    in
        getRandomValue generator