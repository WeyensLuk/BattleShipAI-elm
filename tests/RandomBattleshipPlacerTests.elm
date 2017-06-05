module RandomBattleshipPlacerTests exposing (..)

import Test exposing (..)
import Expect
import BattleshipLogic.RandomBattleshipPlacer exposing (..)
import Model exposing(Battleship)
import Set exposing(..)

suite : Test
suite =
    describe "The RandomBattleshipPlacer module"
        [describe "RandomBattleshipPlacer.getRandomlyPlacedBattleships"
            [ test "make sure we have 5 ships of sizes 2, 3, 3, 4, 5" <|
                \_ ->
                    let 
                        battleships = getRandomlyPlacedBattleships
                    in
                        battleships 
                            |> List.map (\ship -> List.length ship.fields)
                            |> Expect.equal [2, 3, 3, 4, 5]
            , test "make sure all fields start with a letter ranging from A to J" <|
                \_ ->
                    let 
                        battleshipLetters = getRandomlyPlacedBattleships
                            |> List.map (\ship -> ship.fields)
                            |> List.concat
                            |> List.map (\field -> String.left 1 field)
                    in
                        Expect.true "Only values A->J are allowed as the first part of the coordinate"
                            (battleshipLetters
                                |> List.all (\letter -> List.member letter ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]))
            , test "make sure all fields end with a number ranging from 1 to 10" <|
                \_ ->
                    let 
                        battleshipNumbers = getRandomlyPlacedBattleships
                            |> List.map (\ship -> ship.fields)
                            |> List.concat
                            |> List.map (\field -> String.dropLeft 1 field)
                    in
                        Expect.true "Only values 1->10 are allowed as the second part of the coordinate" 
                            (battleshipNumbers
                                |> List.all (\number -> List.member number ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]))
            , test "make sure all fields are unique, can't have any overlapping ships" <|
                \_ ->
                    let 
                        battleshipFields = getRandomlyPlacedBattleships
                            |> List.map (\ship -> ship.fields)
                            |> List.concat
                        battleshipFieldsUnique = 
                            Set.fromList battleshipFields
                    in
                        Expect.equal (List.length battleshipFields) (Set.size battleshipFieldsUnique)
            ]
        ]