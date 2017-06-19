// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

class abstractSudoku {
  List<List<int>> _gameFieldSolved;
  List<List<int>> _gameField;
  List<List<bool>> _userInput;
  List<List<Point<int>>> _regions;

  int controlValue;

  abstractSudoku() {
    controlValue = 1;
  }

  // Checks if the player has solved the sudoku correct
  bool isSolved() {
    for(int i = 0; i < _gameFieldSolved.length; i++) {
      for(int j = 0; j < _gameFieldSolved[0].length; j++) {
        if(_gameFieldSolved[i][j] != _gameField[i][j]) {
          print("Solved: false");
          return false;
        }
      }
    }
    print("Solved: true");
    return true;
  }

  List<List<int>> getGameFieldSolved() {
    return this._gameFieldSolved;
  }

  setGameFieldSolved(List<List<int>> gameField){
    this._gameFieldSolved = gameField;
  }

  List<List<int>> getGameField() {
    return this._gameField;
  }

  setGameField (List<List<int>> gameField){
    this._gameField = gameField;
  }

  List<List<bool>> getUserInput() {
    return this._userInput;
  }

  setUserInput(List<List<bool>> userInput){
    this._userInput = userInput;
  }

  int getControlValue() {
    return this.controlValue;
  }

  setControlValue(int value) {
    this.controlValue = value;
  }

  List<List<Point<int>>> getRegions() {
    return this._regions;
  }

  setRegions(List<List<Point<int>>> value) {
    this._regions = value;
  }

  void setGameCell(int row, int col) {
    print("Set GameCell " + row.toString() + " - " + col.toString());
    print("GameCell before: " + _gameField[row][col].toString());
    print("UserInput: " + _userInput[row][col].toString());
    if(_userInput[row][col]) {
      if (_gameField[row][col] == controlValue)
        _gameField[row][col] = -1;
      else
        _gameField[row][col] = controlValue;
    }

    print("GameCell after: " + _gameField[row][col].toString());
  }

}

class SudokuGameGenerator {

  abstractSudoku _sudoku;

  List<List<int>> _gameFieldSolved;
  List<List<int>> _gameField;
  List<List<bool>> _userInput;

  Random _random = new Random.secure();

  var _sampleSudoku = [
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

  SudokuGameGenerator() {

  }

  List<List<int>> copyList(List<List<int>> copyList) {
    List<List<int>> ret = new List<List<int>>(copyList.length);
    for(int i = 0; i < copyList.length; i++) {
      List<int> list = new List(copyList[0].length);
      for(int j = 0; j < copyList[0].length; j++) {
        list[j] = copyList[i][j];
      }
      ret[i] = list;
    }
    return ret;
  }

  List<List<int>> createUserSudoku(List<List<int>> sudoku) {

    var userSudoku = copyList(sudoku);

    // TODO remove fields from gameField
    // TODO just dummy implementation
    for(int i = 0; i < 3; i++) {
      int row = _random.nextInt(9);
      int col = _random.nextInt(9);
      userSudoku[row][col] = -1;
    }
    return userSudoku;
  }

  // Returns new bool list, where every entry is true, when the corresponding field in sudoku is empty (-1)
  List<List<bool>> createUserInputValues(List<List<int>> sudoku) {
    var inputValues = new List<List<bool>>(sudoku.length);
    for(int i = 0; i < sudoku.length; i++) {
      List<bool> list = new List(sudoku[0].length);
      for(int j = 0; j < sudoku[0].length; j++) {
        if(sudoku[i][j] == -1)
          list[j] = true;
        else
          list[j] = false;
      }
      inputValues[i] = list;
    }
    return inputValues;
  }

  abstractSudoku newGame() {

    // Create new solved sudoku
    _gameFieldSolved = createSudoku();

    // Delete fields
    _gameField = createUserSudoku(_gameFieldSolved);

    // Set empty fields as userInput
    _userInput = createUserInputValues(_gameField);

    _sudoku = new abstractSudoku();
    _sudoku.setGameFieldSolved(_gameFieldSolved);
    _sudoku.setGameField(_gameField);
    _sudoku.setUserInput(_userInput);

    // Create Regions List;
    List<List<Point<int>>> totalList = new List<List<Point<int>>>();
    List<List<Point<int>>> rowList = getRowRegions();
    List<List<Point<int>>> colList = getColRegions();
    List<List<Point<int>>> areaList = getAreaRegions();

    for(List<Point<int>> list in rowList) {
      totalList.add(list);
    }

    for(List<Point<int>> list in colList) {
      totalList.add(list);
    }

    for(List<Point<int>> list in areaList) {
      totalList.add(list);
    }

    _sudoku.setRegions(totalList);

    print("TEST - Sudoku valid?: " + isValid(totalList, _gameFieldSolved).toString());

    return _sudoku;
  }

  // Creates list of row coordinates (Point<int>)
  List<List<Point<int>>>getRowRegions() {
    List<List<Point<int>>> list = new List<List<Point<int>>>();
    for(int i = 0; i < 9; i++) {
      List<Point<int>> singleRow = new List<Point<int>>();
        for(int j = 0; j < 9; j++) {
          Point<int> cell = new Point(i, j);
          singleRow.add(cell);
        }
        list.add(singleRow);
    }
    return list;
  }

  // Creates list of col coordinates (Point<int>)
  List<List<Point<int>>>getColRegions() {
    List<List<Point<int>>> list = new List<List<Point<int>>>();
    for(int i = 0; i < 9; i++) {
      List<Point<int>> singleRow = new List<Point<int>>();
      for(int j = 0; j < 9; j++) {
        Point<int> cell = new Point(j, i);
        singleRow.add(cell);
      }
      list.add(singleRow);
    }
    return list;
  }

  // Creates list of 3x3 area coordinates (Point<int>)
  List<List<Point<int>>>getAreaRegions() {
    List<List<Point<int>>> list = new List<List<Point<int>>>();

    for(int i = 0; i < 9; i += 3) {
      for(int j = 0; j < 9; j += 3) {
        list.add(getSpecificArea(i, i+3, j, j+3));
      }
    }

    return list;
  }


  // returns specific 3x3 area of the sudoku
  List<Point<int>> getSpecificArea(int rowStart, int rowEnd, int colStart, int colEnd) {
    List<Point<int>> area = new List<Point<int>>();

    for(int i = rowStart; i < rowEnd; i++) {
      for(int j = colStart; j < colEnd; j++) {
        area.add(new Point(i, j));
      }
    }
    return area;
  }

  bool isValid(List<List<Point<int>>> regions, List<List<int>> sudoku) {
    for(List<Point<int>> list in regions) {
        if(!checkRegion(list, sudoku)) {
          return false;
        }
    }
    return true;
  }

  bool checkRegion(List<Point<int>> region, List<List<int>> sudoku) {

      List<int> values = new List<int>();
      for(Point<int> point in region) {
        values.add(sudoku[point.x][point.y]);
      }
      for(int i = 1; i < 10; i++) {
        if(!values.contains(i))
          return false;
      }
      return true;
  }

  void printSudoku(List<List<int>> sudoku) {
    for(List<int> i in sudoku) {
      print(i);
    }
    print("");
  }

  List<List<int>> transmorphSudoku(List<List<int>> sudoku){
    List<List<int>> tempSudoku = copyList(sudoku);

    // swap set of rows
    for(int i = 0; i < 3; i++) {
      swapSetOfRows(tempSudoku);
    }
    // swap set of cols
    for(int i = 0; i < 3; i++) {
      tempSudoku = swapSetOfCols(tempSudoku);
    }

    // swap 2 rows in set of rows
    // TODO

    // swap 2 cols in set of cols
    // TODO

    // swap two numbers in total
    for(int i = 0; i < 20; i++)
      swap2Numbers(tempSudoku);

    return tempSudoku;
  }

  void swapSetOfRows(List<List<int>> sudoku) {
    List<List<int>> set1 = new List<List<int>>();
    List<List<int>> set2 = new List<List<int>>();
    int swapSet1 = _random.nextInt(3);
    int swapSet2;
    do {
      swapSet2 = _random.nextInt(3);
    } while(swapSet2 == swapSet1);

    //print("SwapSet1: " + swapSet1.toString() + " - " + swapSet2.toString());

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

  List<List<int>> swapSetOfCols(List<List<int>> sudoku) {
    var transposedSudoku = transposeMatrix(sudoku);
    swapSetOfRows(transposedSudoku);
    return transposeMatrix(transposedSudoku);
  }


  void swap2Numbers(List<List<int>> sudoku) {
    int swap1 = _random.nextInt(9)+1;
    int swap2;
    do {
      swap2 = _random.nextInt(9)+1;
    } while(swap2 == swap1);

    //print("swap1: " + swap1.toString() + " - swap2: " + swap2.toString());

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

    return transmorphSudoku(_sampleSudoku);

    //print("UserInput:");
    //print(userInput);
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


  // TODO implementation
  // returns amount of possible solutions for given sudoku
  int getSudokuSolutions(List<List<int>> sudoku) {

    return 1;
  }

  List<List<int>> getGameField() {
    return _sudoku.getGameField();
  }

  void setGameCell(int row, int col) {
    _sudoku.setGameCell(row, col);
  }

  bool isSolved() {
    return _sudoku.isSolved();
  }

  void setControlValue(String value) {
    int controlValue = int.parse(value);
    _sudoku.setControlValue(controlValue);
    print("Control Value: " + controlValue.toString());
  }
  int getControlValue() {
    return _sudoku.getControlValue();
  }
}