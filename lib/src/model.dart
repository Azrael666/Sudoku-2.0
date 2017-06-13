// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

class SudokuGame {

  List<List<int>> gameFieldSolved;
  List<List<int>> gameField;
  List<List<bool>> userInput;

  int controlValue;
  bool solved = false;
  Random random = new Random.secure();

  var testSudoku = [
    [3,4,8,7,6,2,5,1,9],
    [9,6,5,4,1,3,2,8,7],
    [2,1,7,5,9,8,3,6,4],
    [5,9,3,8,4,6,7,2,1],
    [7,2,6,3,5,1,4,9,8],
    [4,8,1,2,7,9,6,3,5],
    [8,3,4,9,2,7,1,5,6],
    [6,7,2,1,8,5,9,4,3],
    [1,5,9,6,3,4,8,7,2],
  ];

  SudokuGame() {
    controlValue = 1;
  }

  void newGame() {
    gameField = createSudoku();

    // TODO remove fields from gameField
    // TODO just dummy implementation
    for(int i = 0; i < 20; i++) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      gameField[row][col] = -1;
    }

    // Initialize userInput list according to generated Sudoku
    userInput = new List<List<bool>>(gameFieldSolved.length);
    for(int i = 0; i < gameFieldSolved.length; i++) {
      List<bool> list = new List(gameFieldSolved[0].length);
      for(int j = 0; j < gameFieldSolved[0].length; j++) {
        if(gameFieldSolved[i][j] == -1)
          list[j] = true;
        else
          list[j] = false;
      }
      userInput[i] = list;
    }
  }

  void printSudoku(List<List<int>> sudoku) {
    for(List<int> i in sudoku) {
      print(i);
    }
    print("");
  }

  List<List<int>> transmorphSudoku(List<List<int>> sudoku){
    List<List<int>> tempSudoku = new List<List<int>>(sudoku.length);
    for(int i = 0; i < tempSudoku.length; i++) {
      List<int> list = new List<int>(sudoku.length);
      for(int j = 0; j < sudoku[0].length; j++) {
        list[j] = sudoku[i][j];
      }
      tempSudoku[i] = list;
    }


    // swap set of rows
    for(int i = 0; i < 3; i++) {
      swapSetOfRows(tempSudoku);
    }
    // swap set of cols
    // TODO

    // swap 2 rows in set of rows
    // TODO

    // swap 2 cols in set of cols
    // TODO

    // swap two numbers in total
    for(int i = 0; i < 20; i++)
      //swap2Numbers(tempSudoku);

    print("Sudoku valid?: " + checkSudoku(tempSudoku).toString());

    return tempSudoku;
  }

  void swapSetOfRows(List<List<int>> sudoku) {
    List<List<int>> set1 = new List<List<int>>();
    List<List<int>> set2 = new List<List<int>>();
    int swapSet1 = random.nextInt(3);
    int swapSet2;
    do {
      swapSet2 = random.nextInt(3);
    } while(swapSet2 == swapSet1);

    print("SwapSet1: " + swapSet1.toString() + " - " + swapSet2.toString());

    swapSet1 *= 3;
    swapSet2 *= 3;

    set1.add(sudoku[swapSet1]);
    set1.add(sudoku[swapSet1 + 1]);
    set1.add(sudoku[swapSet1 + 2]);

    set2.add(sudoku[swapSet2]);
    set2.add(sudoku[swapSet2 + 1]);
    set2.add(sudoku[swapSet2 + 2]);

    sudoku[swapSet1] = set2[0];
    sudoku[swapSet1 + 1] = set2[1];
    sudoku[swapSet1 + 2] = set2[2];

    sudoku[swapSet2] = set1[0];
    sudoku[swapSet2 + 1] = set1[1];
    sudoku[swapSet2 + 2] = set1[2];

  }

  void swap2Numbers(List<List<int>> sudoku) {
    int swap1 = random.nextInt(9)+1;
    int swap2;
    do {
      swap2 = random.nextInt(9)+1;
    } while(swap2 == swap1);

    print("swap1: " + swap1.toString() + " - swap2: " + swap2.toString());

    for(int i = 0; i < sudoku.length; i++) {
      for (int j = 0; j < sudoku[0].length; j++) {
        if (sudoku[i][j] == swap2)
          sudoku[i][j] = swap1;
        else if (sudoku[i][j] == swap1)
          sudoku[i][j] = swap2;
      }
    }
  }

  List<List<int>> createSudoku() {

    gameFieldSolved = transmorphSudoku(testSudoku);



    //print("UserInput:");
    //print(userInput);

    return gameFieldSolved;
  }

  bool checkSolved() {
    bool solved = true;
    for(int i = 0; i < gameFieldSolved.length; i++) {
      for(int j = 0; j < gameFieldSolved[0].length; j++) {
        if(gameFieldSolved[i][j] != gameField[i][j])
          solved = false;
      }
    }
    if(solved)
      print("Solved: true");
    else
      print("Solved: false");

    return solved;
  }

  // checks if the given sudoku is valid
  bool checkSudoku(List<List<int>> sudoku) {
    for(int i = 1; i < 4; i++) {
      if(!checkRegion(getRegion(sudoku, i))) {
        print(i);
        return false;
      }
    }
    return true;
  }

  // returns specific region of given sudoku
  List<List<int>> getRegion(List<List<int>> sudoku, int regionNumber) {
    switch (regionNumber) {
      case 3: // 3x3 Areas
        return get3x3Area(sudoku);
        break;

      case 2: // COLS
        return transposeMatrix(sudoku);
        break;

      case 1: // ROWS
      default:
        return sudoku;
    }
  }

  // returns transposed matrix
  List<List<int>> transposeMatrix(List<List<int>> matrix) {
    // Initialize List
    List<List<int>> transposedMatrix = new List<List<int>>(matrix.length);
    for(int i = 0; i < transposedMatrix.length; i++) {
      transposedMatrix[i] = new List<int>(matrix[i].length);
    }

    // swap elements
    for(int i = 0; i < matrix.length; i++) {
      for(int j = 0; j < matrix[i].length; j++) {
        transposedMatrix[j][i] = matrix[i][j];
      }
    }
    return transposedMatrix;
  }

  // returns sudoku sorted by specific areas
  List<List<int>> get3x3Area(List<List<int>> matrix) {
    List<List<int>> areaList = new List<List<int>>();

    for(int i = 1; i < 10; i += 3) {
      for(int j = 1; j < 10; j += 3) {
        areaList.add(getSpecificArea(matrix, i, i+2, j, j+2));
      }
    }

    return areaList;
  }

  // returns specific 3x3 area of the sudoku
  List<int> getSpecificArea(List<List<int>> matrix, int rowStart, int rowEnd, int colStart, int colEnd) {
    List<int> area = new List<int>();

    for(int i = rowStart-1; i < rowEnd; i++) {
      for(int j = colStart-1; j < colEnd; j++) {
        area.add(matrix[i][j]);
      }
    }
    return area;
  }

  // checks if the given region is valid
  bool checkRegion(List<List<int>> region) {
    for(List<int> regionElement in region) {
      for(int i = regionElement[0]; i < regionElement.length; i++) {
        if(!regionElement.contains(i)) {
          return false;
        }
      }
    }
    return true;
  }

  // TODO implementation
  // returns amount of possible solutions for given sudoku
  int getSudokuSolutions(List<List<int>> sudoku) {

    return 1;
  }

  List<List<int>> getGameField() {
    return gameField;
  }

  void setGameCell(int row, int col) {
    print("Set GameCell " + row.toString() + " - " + col.toString());
    print("GameCell before: " + gameField[row][col].toString());
    print("UserInput: " + userInput[row][col].toString());
    if(userInput[row][col]) {
      if (gameField[row][col] == controlValue)
        gameField[row][col] = -1;
      else
        gameField[row][col] = controlValue;
    }

    print("GameCell after: " + gameField[row][col].toString());
  }

  void setControlValue(String value) {
    controlValue = int.parse(value);
    print("Control Value: " + controlValue.toString());
  }
  int getControlValue() {
    return controlValue;
  }
}