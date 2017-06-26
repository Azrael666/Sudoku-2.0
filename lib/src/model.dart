// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

enum Colors {COLOR_STANDARD, COLOR_STANDARD_DARK, COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6, COLOR_7, COLOR_8, COLOR_9}
enum GameTypes {STANDARD_SUDOKU, X_SUDOKU, HYPER_SUDOKU, MIDDELPOINT_SUDOKU, COLOR_SUDOKU, NONOMINO_SUDOKU}


enum BorderType {THICK,THIN}

class Sides{
  BorderType left,bottom,right,top;

  int row,col;

  toString() =>"left: $left, bottom:$bottom, right:$right, top:$top ($row,$col)";
}



class abstractSudoku {
  List<List<int>> _gameFieldSolved;
  List<List<int>> _gameField;
  List<List<bool>> _userInput;
  List<List<Point<int>>> _regions;
  List<List<Colors>> _colors;

  List<List<Sides>> _sides;

  int _controlValue;

  abstractSudoku() {
    _controlValue = 1;

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
    return this._controlValue;
  }

  setControlValue(int value) {
    this._controlValue = value;
  }

  List<List<Point<int>>> getRegions() {
    return this._regions;
  }

  setRegions(List<List<Point<int>>> value) {
    this._regions = value;
  }

  List<List<Colors>> getColors() {
    return this._colors;
  }

  List<List<Sides>> getSides() {
    return this._sides;
  }
  setSides(List<List<Sides>> sides){
    this._sides= sides;
  }

  setColors(List<List<Colors>> colors) {
    this._colors = colors;
  }

  void setGameCell(int row, int col) {
    print("Set GameCell " + row.toString() + " - " + col.toString());
    print("GameCell before: " + _gameField[row][col].toString());
    print("UserInput: " + _userInput[row][col].toString());
    if(_userInput[row][col]) {
      if (_gameField[row][col] == _controlValue)
        _gameField[row][col] = -1;
      else
        _gameField[row][col] = _controlValue;
    }

    print("GameCell after: " + _gameField[row][col].toString());
  }

}

class SudokuGameGenerator {

  abstractSudoku _sudoku;

  List<List<int>> _gameFieldSolved;
  List<List<int>> _gameField;
  List<List<bool>> _userInput;
  List<String> jsonPaths;
  List<String> jsonLevelFiles;

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
    initialize();
  }

  void initialize() {
    jsonLevelFiles = new List<String>();

    String folder = "nonomino";
    for (int i = 1; i < 4; i++) {
      String path = "../levels/" + folder + "/level" + i.toString() + ".json";
      loadJsonFiles(path);
    }

  }


  loadJsonFiles(String path) async {
    await HttpRequest.getString(path).then((content) => addLevelToList(content, path));
  }

  void addLevelToList(String content, String path) {
    jsonLevelFiles.add(content);
    print("Loaded File: " + path);
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
    // Currently just dummy implementation
    for(int i = 0; i < 3; i++) {
      int row = _random.nextInt(9);
      int col = _random.nextInt(9);
      userSudoku[row][col] = -1;
    }
    return userSudoku;
  }

  // Returns new bool list, where every entry is true, when the corresponding field in sudoku is empty (-1)
  List<List<bool>> createUserInputValues(List<List<int>> sudoku, int emptyValue) {
    var inputValues = new List<List<bool>>(sudoku.length);
    for(int i = 0; i < sudoku.length; i++) {
      List<bool> list = new List(sudoku[0].length);
      for(int j = 0; j < sudoku[0].length; j++) {
        if(sudoku[i][j] == emptyValue)
          list[j] = true;
        else
          list[j] = false;
      }
      inputValues[i] = list;
    }
    return inputValues;
  }



  abstractSudoku newGame(GameTypes gameType) {
    print(gameType);
    switch (gameType) {
      case GameTypes.X_SUDOKU:
        return newXSudoku();
        break;
      case GameTypes.HYPER_SUDOKU:
        return newHyperSudoku();
        break;
      case GameTypes.MIDDELPOINT_SUDOKU:
        return newMiddlepointSudoku();
        break;
      case GameTypes.COLOR_SUDOKU:
        return newColorSudoku();
        break;
      case GameTypes.NONOMINO_SUDOKU:
        return newNonominoSudoku();
        break;

      case GameTypes.STANDARD_SUDOKU:
      default:
        return newStandardSudoku();
        break;
    }


  }

  //TODO implement Generator
  abstractSudoku newXSudoku() {
    // Dummy return value
    return newStandardSudoku();
  }

  //TODO implement Generator
  abstractSudoku newHyperSudoku() {
    // Dummy return value
    return newStandardSudoku();
  }

  //TODO implement Generator
  abstractSudoku newMiddlepointSudoku() {
    // Dummy return value
    return newStandardSudoku();
  }

  //TODO implement Generator
  abstractSudoku newColorSudoku() {
    // Dummy return value
    return newStandardSudoku();
  }

  //TODO implement Generator
  abstractSudoku newNonominoSudoku() {
    // Dummy return value
    Map level = JSON.decode(jsonLevelFiles[1]);

    abstractSudoku sudoku = new abstractSudoku();

    List<List<int>> gameFieldSolved = level["fields"];
    List<List<bool>> userInput = createUserInputValues(level["empty"], 1);
    List<List<int>> gameField = getGameFieldFromFile(createUserSudoku(gameFieldSolved), userInput);;

    // Create Regions List;
    // TODO add color regions
    List<List<Point<int>>> totalList = new List<List<Point<int>>>();
    List<List<Point<int>>> rowList = getRowRegions();
    List<List<Point<int>>> colList = getColRegions();

    for(List<Point<int>> list in rowList) {
      totalList.add(list);
    }

    for(List<Point<int>> list in colList) {
      totalList.add(list);
    }


    // Set colors
    List<List<int>> colorsFile = level["colors"];
    List<List<Colors>> colors = new List<List<Colors>>(gameFieldSolved.length);

    for(int i = 0; i < colorsFile.length; i++) {
      List<Colors> colorRow = new List<Colors>(colorsFile[0].length);
      for (int j = 0; j < colorsFile[0].length; j++) {

        switch (colorsFile[i][j]) {
          case 0:
            colorRow[j] = Colors.COLOR_1;
            break;
          case 1:
            colorRow[j] = Colors.COLOR_2;
            break;
          case 2:
            colorRow[j] = Colors.COLOR_3;
            break;
          case 3:
            colorRow[j] = Colors.COLOR_4;
            break;
          case 4:
            colorRow[j] = Colors.COLOR_5;
            break;
          case 5:
            colorRow[j] = Colors.COLOR_6;
            break;
          case 6:
            colorRow[j] = Colors.COLOR_7;
            break;
          case 7:
            colorRow[j] = Colors.COLOR_8;
            break;
          case 8:
            colorRow[j] = Colors.COLOR_9;
            break;
        }
      }
      colors[i] = colorRow;
    }





    sudoku.setGameFieldSolved(gameFieldSolved);
    sudoku.setGameField(gameField);
    sudoku.setUserInput(userInput);
    sudoku.setRegions(totalList);
    sudoku.setColors(colors);



    print("Difficulty: " + level["difficulty"]);
    print("GamefieldSolved:");
    printSudoku(gameFieldSolved);
    print("Gamefield:");
    printSudoku(gameField);
    print("UserInput: " + userInput.toString());

    return sudoku;
  }

  abstractSudoku newStandardSudoku() {

    // Create new solved sudoku
    _gameFieldSolved = createSudoku();

    // Delete fields
    _gameField = createUserSudoku(_gameFieldSolved);

    // Set empty fields as userInput
    _userInput = createUserInputValues(_gameField, -1);

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

    // Create Colors
    List<List<Colors>> colors = new List<List<Colors>>(_gameFieldSolved.length);
    for(int i = 0; i < _gameFieldSolved.length; i++) {
      List<Colors> colorRow  = new List<Colors>(_gameFieldSolved[0].length);
      for(int j = 0; j < _gameFieldSolved[0].length; j++) {

        // Test Colors
        switch(j) {
          case 0:
            colorRow[j] = Colors.COLOR_1;
            break;
          case 1:
            colorRow[j] = Colors.COLOR_2;
            break;
          case 2:
            colorRow[j] = Colors.COLOR_3;
            break;
          case 3:
            colorRow[j] = Colors.COLOR_4;
            break;
          case 4:
            colorRow[j] = Colors.COLOR_5;
            break;
          case 5:
            colorRow[j] = Colors.COLOR_6;
            break;
          case 6:
            colorRow[j] = Colors.COLOR_7;
            break;
          case 7:
            colorRow[j] = Colors.COLOR_8;
            break;
          case 8:
            colorRow[j] = Colors.COLOR_9;
            break;
        }

        // Standard Colors
        if((i >= 3 && i <= 5 && (j < 3 || j > 5)) || (j >= 3 && j <= 5 && (i < 3 || i > 5)))
          colorRow[j] = Colors.COLOR_STANDARD_DARK;
        else
          colorRow[j] = Colors.COLOR_STANDARD;

      }
      colors[i] = colorRow;
    }


    List<List<Sides>> sides = new List();
    for(int i=0;i<9;i++){
      List<Sides> lis = new List();
      for(int i1=0;i1<9;i1++){
        Sides s= new Sides();
        s.left = (i1%3==0) ?BorderType.THICK:BorderType.THIN;
        s.right = (i1%3==2) ? BorderType.THICK:BorderType.THIN;
        s.top = (i%3==0)?BorderType.THICK:BorderType.THIN;
        s.bottom = (i%3==2)?BorderType.THICK:BorderType.THIN;


        s.row=i;
        s.col=i1;
        lis.add(s);
      }
      sides.add(lis);


    }
    _sudoku.setSides(sides);


    _sudoku.setColors(colors);

    return _sudoku;
  }

  List<List<int>> getGameFieldFromFile(List<List<int>> sudokuSolved, List<List<bool>> userInputValues) {
    List<List<int>> gameField = copyList(sudokuSolved);
    for(int i = 0; i < userInputValues.length; i++) {
      for(int j = 0; j < userInputValues[0].length; j++) {
        if(userInputValues[i][j])
          gameField[i][j] = -1;
      }
    }
    return gameField;
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