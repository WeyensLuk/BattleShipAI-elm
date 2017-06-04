module BattleshipProbabilityCalculatorTests exposing (..)

import Test exposing (..)
import Expect
import BattleshipProbabilityCalculator exposing (..)
import Model exposing(BattleshipGrid, Cell)
import Array2D exposing(..)

suite : Test
suite =
    describe "The BattleshipProbabilityCalculator module"
        [describe "BattleshipProbabilityCalculator.calculateProbabilityFor"
            [test "correctly sets the probability rating for an empty Grid for a ship of size 3" <|
                \_ ->
                    let grid = 
                        repeat 10 10 (Cell Model.NotShot 0)
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
            ]
        ]
