module BattleshipProbabilityCalculatorTests exposing (..)

import Test exposing (..)
import Expect
import BattleshipLogic.BattleshipProbabilityCalculator exposing (..)
import Model exposing(BattleshipGrid, Cell)
import Array2D exposing(..)

suite : Test
suite =
    describe "The BattleshipProbabilityCalculator module"
        [describe "BattleshipProbabilityCalculator.calculateProbabilityFor"
            [test "correctly sets the probability rating for an empty Grid for a ship of size 3" <|
                \_ ->
                    let 
                        grid = repeat 10 10 (Cell Model.NotShot 0)
                    in
                        grid
                            |> calculateProbabilityFor submarine
                            |> map (\cell -> cell.probability)
                            |> Expect.equal (fromList   [ [2, 3, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        , [3, 4, 5, 5, 5, 5, 5, 5, 4, 3]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [3, 4, 5, 5, 5, 5, 5, 5, 4, 3]
                                                        , [2, 3, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        ])
            , test "correctly adjusts the probability rating for a Grid with a miss at B2 for a ship of size 3" <|
                \_ ->
                    let 
                        grid = repeat 10 10 (Cell Model.NotShot 0)
                    in
                        
                        grid
                            |> set 1 1 (Cell Model.Miss 0)
                            |> calculateProbabilityFor submarine
                            |> map (\cell -> cell.probability)
                            |> Expect.equal (fromList   [ [2, 2, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        , [2, 0, 3, 4, 5, 5, 5, 5, 4, 3]
                                                        , [4, 3, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 4, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [3, 4, 5, 5, 5, 5, 5, 5, 4, 3]
                                                        , [2, 3, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        ])
            , test "correctly adjusts the probability rating for a Grid with a hit at B2 for a ship of size 3" <|
                \_ ->
                    let 
                        grid = repeat 10 10 (Cell Model.NotShot 0)
                    in
                        
                        grid
                            |> set 1 1 (Cell Model.Hit 0)
                            |> calculateProbabilityFor submarine
                            |> map (\cell -> cell.probability)
                            |> Expect.equal (fromList   [ [2, 2, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        , [2, 0, 3, 4, 5, 5, 5, 5, 4, 3]
                                                        , [4, 3, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 4, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [3, 4, 5, 5, 5, 5, 5, 5, 4, 3]
                                                        , [2, 3, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        ])
            , test "a ship of size 3 can't fit between misses on B2 and B4" <|
                \_ ->
                    let 
                        grid = repeat 10 10 (Cell Model.NotShot 0)
                    in
                        
                        grid
                            |> set 1 1 (Cell Model.Hit 0)
                            |> set 1 3 (Cell Model.Hit 0)
                            |> calculateProbabilityFor submarine
                            |> map (\cell -> cell.probability)
                            |> Expect.equal (fromList   [ [2, 2, 4, 3, 4, 4, 4, 4, 3, 2]
                                                        , [2, 0, 2, 0, 3, 4, 5, 5, 4, 3]
                                                        , [4, 3, 6, 4, 6, 6, 6, 6, 5, 4]
                                                        , [4, 4, 6, 5, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [4, 5, 6, 6, 6, 6, 6, 6, 5, 4]
                                                        , [3, 4, 5, 5, 5, 5, 5, 5, 4, 3]
                                                        , [2, 3, 4, 4, 4, 4, 4, 4, 3, 2]
                                                        ])
            ]
        ]
