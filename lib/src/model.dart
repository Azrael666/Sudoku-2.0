// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

enum Colors {COLOR_STANDARD, COLOR_STANDARD_DARK, COLOR_HIGHLIGHTED, COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6, COLOR_7, COLOR_8, COLOR_9}
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

  void setControlValue(String value) {
    int controlValue = int.parse(value);
    this._controlValue = controlValue;
    print("Control Value: " + controlValue.toString());
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

  setColors(List<List<Colors>> colors) {
    this._colors = colors;
  }

  List<List<Sides>> getSides() {
    return this._sides;
  }
  setSides(List<List<Sides>> sides){
    this._sides= sides;
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

  // Json paths & levelFiles
  List<String> jsonPaths;
  List<String> jsonLevelFiles;

  Random _random = new Random.secure();

  // List of middlepoint positions
  List<Point<int>> middlepoints;
  List<List<Point<int>>> diagonalPoints;
  List<List<Point<int>>> hyperPoints;
  List<List<Point<int>>> colorPoints;

  SudokuGameGenerator() {
    // initialize middlepoint positions
    middlepoints = new List<Point<int>>();
    for (int i = 1; i <= 7; i = i + 3) {
      for (int j = 1; j <= 7; j = j + 3) {
        middlepoints.add(new Point(i, j));
      }
    }

    // initialize diagonal positions
    diagonalPoints = new List<List<Point<int>>>();
    List<Point<int>> firstDiagonal = new List<Point<int>>();
    List<Point<int>> secondDiagonal = new List<Point<int>>();
    for (int i = 0; i < 9; i++) {
      // first diagonal from top left to bottom right
      Point<int> firstPoint = new Point(i, i);
      firstDiagonal.add(firstPoint);

      // second diagonal from bottom left to top right
      Point<int> secondPoint = new Point(i, 8 - i);
      secondDiagonal.add(secondPoint);
    }
    diagonalPoints.add(firstDiagonal);
    diagonalPoints.add(secondDiagonal);

    // initialize hyper positions
    hyperPoints = new List<List<Point<int>>>();

    List<Point<int>> hyperSquare1 = new List<Point<int>>();
    List<Point<int>> hyperSquare2 = new List<Point<int>>();
    List<Point<int>> hyperSquare3 = new List<Point<int>>();
    List<Point<int>> hyperSquare4 = new List<Point<int>>();

    for (int i = 1; i <= 3; i++) {
      for (int j = 1; j <= 3; j++) {
        hyperSquare1.add(new Point(i, j));
        hyperSquare2.add(new Point(i + 4, j));
        hyperSquare3.add(new Point(i, j + 4));
        hyperSquare4.add(new Point(i + 4, j + 4));
      }
    }
    hyperPoints.add(hyperSquare1);
    hyperPoints.add(hyperSquare2);
    hyperPoints.add(hyperSquare3);
    hyperPoints.add(hyperSquare4);

    // initialize color positions
    colorPoints = new List<List<Point<int>>>();
    List<Point<int>> Color1 = new List<Point<int>>();
    List<Point<int>> Color2 = new List<Point<int>>();
    List<Point<int>> Color3 = new List<Point<int>>();
    List<Point<int>> Color4 = new List<Point<int>>();
    List<Point<int>> Color5 = new List<Point<int>>();
    List<Point<int>> Color6 = new List<Point<int>>();
    List<Point<int>> Color7 = new List<Point<int>>();
    List<Point<int>> Color8 = new List<Point<int>>();
    List<Point<int>> Color9 = new List<Point<int>>();

    for (int i = 0; i <= 6; i = i + 3) {
      for (int j = 0; j <= 6; j = j + 3) {
        Color1.add(new Point(i, j));
        Color2.add(new Point(i, j + 1));
        Color3.add(new Point(i, j + 2));
        Color4.add(new Point(i + 1, j));
        Color5.add(new Point(i + 1, j + 1));
        Color6.add(new Point(i + 1, j + 2));
        Color7.add(new Point(i + 2, j));
        Color8.add(new Point(i + 2, j + 1));
        Color9.add(new Point(i + 2, j + 2));
      }
    }
    colorPoints.add(Color1);
    colorPoints.add(Color2);
    colorPoints.add(Color3);
    colorPoints.add(Color4);
    colorPoints.add(Color5);
    colorPoints.add(Color6);
    colorPoints.add(Color7);
    colorPoints.add(Color8);
    colorPoints.add(Color9);


    // Load jsonFiles for nonomino sudokus
    jsonLevelFiles = new List<String>();

    String folder = "nonomino";
    for (int i = 1; i < 4; i++) {
      String path = "levels/" + folder + "/level" + i.toString() + ".json";
      loadJsonFiles(path);
    }
  }

  // asynchronously loads jsonFiles for nonomino sudokus
  loadJsonFiles(String path) async {
    await HttpRequest.getString(path).then((content) =>
        addLevelToList(content, path));
  }

  void addLevelToList(String content, String path) {
    jsonLevelFiles.add(content);
    print("Loaded File: " + path);
  }

  List<List<int>> copyList(List<List<int>> copyList) {
    List<List<int>> ret = new List<List<int>>();

    for (int i = 0; i < copyList.length; i++) {
      List<int> list = new List<int>();

      for (int j = 0; j < copyList[i].length; j++) {
        list.add(copyList[i][j]);
      }
      ret.add(list);
    }
    return ret;
  }

  List<List<int>> createUserSudoku(List<List<int>> sudoku) {
    var userSudoku = copyList(sudoku);

    // TODO remove fields from gameField
    // Currently just dummy implementation
    for (int i = 0; i < 5; i++) {
      int row = _random.nextInt(9);
      int col = _random.nextInt(9);
      userSudoku[row][col] = -1;
    }
    return userSudoku;
  }

  // Returns new bool list, where every entry is true, when the corresponding field in sudoku is empty (-1)
  List<List<bool>> createUserInputValues(List<List<int>> sudoku,
      int emptyValue) {
    var inputValues = new List<List<bool>>(sudoku.length);
    for (int i = 0; i < sudoku.length; i++) {
      List<bool> list = new List(sudoku[0].length);
      for (int j = 0; j < sudoku[0].length; j++) {
        if (sudoku[i][j] == emptyValue)
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

    return (gameType == GameTypes.NONOMINO_SUDOKU ?
    newNonominoSudoku() :
    newSudoku(gameType));

    /*
    if(gameType == GameTypes.NONOMINO_SUDOKU) {
      return newNonominoSudoku();
    } else {
      return newSudoku(gameType);
    }
    */

  }

  abstractSudoku newNonominoSudoku() {
    Map level = JSON.decode(jsonLevelFiles[1]);

    abstractSudoku sudoku = new abstractSudoku();

    List<List<int>> gameFieldSolved = level["fields"];
    List<List<bool>> userInput = createUserInputValues(level["empty"], 1);
    List<List<int>> gameField = getGameFieldFromFile(
        gameFieldSolved, userInput);
    ;

    /*

    // Create Regions List;
    // TODO Regions necessary?
    // TODO add color regions
    List<List<Point<int>>> totalList = new List<List<Point<int>>>();
    List<List<Point<int>>> rowList = getRowRegions();
    List<List<Point<int>>> colList = getColRegions();

    for (List<Point<int>> list in rowList) {
      totalList.add(list);
    }

    for (List<Point<int>> list in colList) {
      totalList.add(list);
    }

    */


    // Set colors
    List<List<int>> colorsFile = level["colors"];
    List<List<Colors>> colors = new List<List<Colors>>(gameFieldSolved.length);

    for (int i = 0; i < colorsFile.length; i++) {
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


    List<List<Sides>> sides = new List();
    for (int i = 0; i < 9; i++) {
      List<Sides> lis = new List();
      for (int i1 = 0; i1 < 9; i1++) {
        Sides s = new Sides();
        s.left = s.right = s.top = s.bottom = BorderType.THIN;


        if ((i1 == 0) || ((i1 - 1) >= 0 && colors[i][i1] != colors[i][i1 - 1]))
          s.left = BorderType.THICK;

        if ((i1 == 8) || (i1 + 1) <= 8 && colors[i][i1] != colors[i][i1 + 1])
          s.right = BorderType.THICK;

        if ((i == 0) || (i - 1) >= 0 && colors[i][i1] != colors[i - 1][i1])
          s.top = BorderType.THICK;

        if ((i == 8) || (i + 1) <= 8 && colors[i][i1] != colors[i + 1][i1])
          s.bottom = BorderType.THICK;


        s.row = i;
        s.col = i1;
        lis.add(s);
      }
      sides.add(lis);
    }
    sudoku.setSides(sides);


    sudoku.setGameFieldSolved(gameFieldSolved);
    sudoku.setGameField(gameField);
    sudoku.setUserInput(userInput);
    //sudoku.setRegions(totalList);
    sudoku.setColors(colors);


    /*

    print("Difficulty: " + level["difficulty"]);
    print("GamefieldSolved:");
    printSudoku(gameFieldSolved);
    print("Gamefield:");
    printSudoku(gameField);
    print("UserInput: " + userInput.toString());
    */

    return sudoku;
  }

  List<List<int>> generateGame(GameTypes gameType) {
    List<List<int>> sudoku = new List<List<int>>();

    // initialize every value of the sudoku field with -1
    for (int i = 0; i < 9; i++) {
      List<int> row = new List<int>();
      for (int j = 0; j < 9; j++) {
        row.add(-1);
      }
      sudoku.add(row);
    }

    // Initialize every set with numbers 1-9
    List<List<List<int>>> sets = new List<List<List<int>>>();

    // Rows
    for (int i = 0; i < 9; i++) {
      List<List<int>> row = new List<List<int>>();

      // Cols
      for (int j = 0; j < 9; j++) {
        List<int> set = new List<int>();

        // Numbers 1-9
        for (int k = 1; k < 10; k++) {
          set.add(k);
        }
        row.add(set);
      }
      sets.add(row);
    }

    //final cancelTimerSpeed = const Duration(milliseconds: 5000);
    //Timer test = new Timer(cancelTimerSpeed, callback);

    Stopwatch timeStopwath = new Stopwatch();
    timeStopwath.start();
    // Generate sudoku
    //counter = 0;

    bool found = false;
    int count = 1;
    do {
      print("Count: " + count.toString());
      Stopwatch cancelTimer = new Stopwatch();
      cancelTimer.start();
      found = createGame(sudoku, sets, gameType, cancelTimer);
      count++;
    } while (!found && timeStopwath.elapsedMilliseconds < 10000);

    if (found) {
      printSudoku(sudoku);
      print("Found Sudoku");
      print("Needed time: " + timeStopwath.elapsedMilliseconds.toString());
      return sudoku;
    } else {
      print("Found no Sudoku");
      return null;
    }
  }

  bool createGame(List<List<int>> sudoku, List<List<List<int>>> sets,
      GameTypes gameType, Stopwatch cancelTimer) {
    if (cancelTimer.elapsedMilliseconds > 1000)
      return false;
    // find next empty position
    Point<int> nextPosition = findNextPosition(sudoku);

    // return true if the sudoku board is complety filled
    if (nextPosition != null) {
      int positionX = nextPosition.x;
      int positionY = nextPosition.y;

      // get set with possible numbers for current position
      List<int> positionNumberSet = new List<int>.from(
          sets[positionX][positionY]);

      int positionNumberSetSize = positionNumberSet.length;

      // continue, if there is a possible number for the current position
      if (positionNumberSetSize > 0) {
        // create new numbers 0 - positionNumberSetSize
        List<int> rand = new List<int>();
        for (int i = 0; i < positionNumberSetSize; i++) {
          rand.add(i);
        }
        // shuffle numbers for random order
        rand.shuffle();

        // check every possible number for this position
        for (int i = 0; i < positionNumberSetSize; i++) {
          // get random possible number from set
          int index = rand.removeAt(0);
          int nextNumber = positionNumberSet[index];

          // fill number in current position field of sudoku
          sudoku[positionX][positionY] = nextNumber;
          //printSudoku(sudoku);

          // remove chosen number from all sets of position's row, column & 3x3 area

          List<List<List<int>>> nextSets = removeNumberFromSets(
              positionX, positionY, nextNumber, sets, gameType);

          // recursive call for finding next number
          if (createGame(sudoku, nextSets, gameType, cancelTimer)) {
            return true;
          } else {
            sudoku[positionX][positionY] = -1;
            continue;
          }
        }
        return false;
      } else
        return false;
    } else {
      print("Sudoku finished");
      return true;
    }
  }

  Point<int> findNextPosition(List<List<int>> sudoku) {

    /*
    // random
    List<Point<int>> emptyCells = new List<Point<int>>();
    for(int i = 0; i < sudoku.length; i++) {
      for(int j = 0; j < sudoku[0].length; j++) {
        if(sudoku[i][j] == -1)
          emptyCells.add(new Point(i, j));
      }
    }

    if(emptyCells.length == 0)
      return null;
    else {
      int index =_random.nextInt(emptyCells.length);
      return emptyCells[index];
    }

    */

    // top left to bottom right
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (sudoku[i][j] == -1)
          return new Point(i, j);
      }
    }

    return null;
  }

  List<List<List<int>>> removeNumberFromSets(int x, int y, int number,
      List<List<List<int>>> sets, GameTypes gameType) {
    // Complete copy of given sets

    List<List<List<int>>> nextSets = new List<List<List<int>>>();

    // for each row
    for (int i = 0; i < sets.length; i++) {
      List<List<int>> nextRow = new List<List<int>>();

      // for each col in row
      for (int j = 0; j < sets[i].length; j++) {
        List<int> nextCol = new List<int>();

        List<int> set = sets[i][j];

        for (int k = 0; k < set.length; k++) {
          int temp = set[k];
          nextCol.add(temp);
        }

        nextRow.add(nextCol);
      }

      nextSets.add(nextRow);
    }


    // Removal

    // Rows & Cols
    removeNumberFromRowsAndCols(x, y, number, nextSets);

    // 3x3 area
    if (gameType != GameTypes.NONOMINO_SUDOKU)
      removeNumberFrom3x3Area(x, y, number, nextSets);

    // diagonals
    if (gameType == GameTypes.X_SUDOKU)
      removeNumberFromDiagonals(x, y, number, nextSets);

    // Hyper
    if (gameType == GameTypes.HYPER_SUDOKU)
      removeNumberFromHyperSquares(x, y, number, nextSets);

    // Middlepoint
    if (gameType == GameTypes.MIDDELPOINT_SUDOKU)
      removeNumberFromMiddlepoints(x, y, number, nextSets);

    // Color
    if (gameType == GameTypes.COLOR_SUDOKU)
      removeNumberFromColors(x, y, number, nextSets);

    return nextSets;
  }

  void removeNumberFromRowsAndCols(int x, int y, int number,
      List<List<List<int>>> sets) {
    for (int i = 0; i < 9; i++) {
      int rowIndex = sets[i][y].indexOf(number);
      if (rowIndex >= 0)
        sets[i][y].removeAt(rowIndex);

      int colIndex = sets[x][i].indexOf(number);
      if (colIndex >= 0)
        sets[x][i].removeAt(colIndex);
    }
  }

  void removeNumberFrom3x3Area(int x, int y, int number,
      List<List<List<int>>> sets) {
    int bx = x - x % 3;
    int by = y - y % 3;
    for (int i = bx; i < bx + 3; i++) {
      for (int j = by; j < by + 3; j++) {
        int cellIndex = sets[i][j].indexOf(number);
        if (cellIndex >= 0)
          sets[i][j].removeAt(cellIndex);
      }
    }
  }

  void removeNumberFromDiagonals(int x, int y, int number,
      List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    for (List<Point<int>> diagonal in diagonalPoints) {
      if (diagonal.contains(positionPoint)) {
        for (Point<int> point in diagonal) {
          int cellIndex = sets[point.x][point.y].indexOf(number);
          if (cellIndex >= 0)
            sets[point.x][point.y].removeAt(cellIndex);
        }
      }
    }
  }

  void removeNumberFromHyperSquares(int x, int y, int number,
      List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    for (List<Point<int>> hyper in hyperPoints) {
      if (hyper.contains(positionPoint)) {
        for (Point<int> point in hyper) {
          int cellIndex = sets[point.x][point.y].indexOf(number);
          if (cellIndex >= 0)
            sets[point.x][point.y].removeAt(cellIndex);
        }
      }
    }
  }

  void removeNumberFromMiddlepoints(int x, int y, int number,
      List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    if (middlepoints.contains(positionPoint)) {
      for (Point<int> point in middlepoints) {
        int cellIndex = sets[point.x][point.y].indexOf(number);
        if (cellIndex >= 0)
          sets[point.x][point.y].removeAt(cellIndex);
      }
    }
  }

  void removeNumberFromColors(int x, int y, int number,
      List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    for (List<Point<int>> color in colorPoints) {
      if (color.contains(positionPoint)) {
        for (Point<int> point in color) {
          int cellIndex = sets[point.x][point.y].indexOf(number);
          if (cellIndex >= 0)
            sets[point.x][point.y].removeAt(cellIndex);
        }
      }
    }
  }


  abstractSudoku newSudoku(GameTypes gameType) {
    abstractSudoku sudoku = new abstractSudoku();

    // Create new solved sudoku
    List<List<int>> gameFieldSolved = generateGame(gameType);

    // Delete fields
    List<List<int>> gameField = createUserSudoku(gameFieldSolved);

    // Set empty fields as userInput
    List<List<bool>>userInput = createUserInputValues(gameField, -1);

    sudoku.setGameFieldSolved(gameFieldSolved);
    sudoku.setGameField(gameField);
    sudoku.setUserInput(userInput);


    // TODO Regions necessary?
    /*
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

  */


    //TODO make variable, add other color schemes
    // Create Colors
    List<List<Colors>> colors = new List<List<Colors>>(gameFieldSolved.length);

    for(int i = 0; i < gameFieldSolved.length; i++) {
      List<Colors> colorRow  = new List<Colors>(gameFieldSolved[0].length);
      for(int j = 0; j < gameFieldSolved[0].length; j++) {

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

    if(gameType == GameTypes.X_SUDOKU){
      for(int i=0;i<9;i++){
        colors[8-i][i]  = colors[i][i] = Colors.COLOR_HIGHLIGHTED;

      }
    }

    if(gameType == GameTypes.MIDDELPOINT_SUDOKU){
      for(int i=0;i<3;i++){
        for(int i1=0;i1<3;i1++){
          colors[i*3+1][i1*3+1] = Colors.COLOR_HIGHLIGHTED;
        }
      }
    }


    if(gameType  == GameTypes.HYPER_SUDOKU){
      for(int i=0;i<2;i++){
        for(int i1=0;i1<2;i1++){

          for(int i2=0;i2<3;i2++){
            for(int i3=0;i3<3;i3++){
              colors[i*4+1+i2][i1*4+1+i3] = Colors.COLOR_HIGHLIGHTED;

            }
          }
        }

      }
    }

    List<List<Sides>> sides = new List();
    for (int i = 0; i < 9; i++) {
      List<Sides> lis = new List();
      for (int i1 = 0; i1 < 9; i1++) {
        Sides s = new Sides();
        s.left = (i1 % 3 == 0) ? BorderType.THICK : BorderType.THIN;
        s.right = (i1 % 3 == 2) ? BorderType.THICK : BorderType.THIN;
        s.top = (i % 3 == 0) ? BorderType.THICK : BorderType.THIN;
        s.bottom = (i % 3 == 2) ? BorderType.THICK : BorderType.THIN;


        s.row = i;
        s.col = i1;
        lis.add(s);
      }
      sides.add(lis);
    }
    sudoku.setSides(sides);


    sudoku.setColors(colors);

    return sudoku;
  }


  List<List<int>> getGameFieldFromFile(List<List<int>> sudokuSolved,
      List<List<bool>> userInputValues) {
    List<List<int>> gameField = copyList(sudokuSolved);
    for (int i = 0; i < userInputValues.length; i++) {
      for (int j = 0; j < userInputValues[0].length; j++) {
        if (userInputValues[i][j])
          gameField[i][j] = -1;
      }
    }
    return gameField;
  }

  // Creates list of row coordinates (Point<int>)
  List<List<Point<int>>> getRowRegions() {
    List<List<Point<int>>> list = new List<List<Point<int>>>();
    for (int i = 0; i < 9; i++) {
      List<Point<int>> singleRow = new List<Point<int>>();
      for (int j = 0; j < 9; j++) {
        Point<int> cell = new Point(i, j);
        singleRow.add(cell);
      }
      list.add(singleRow);
    }
    return list;
  }

  // Creates list of col coordinates (Point<int>)
  List<List<Point<int>>> getColRegions() {
    List<List<Point<int>>> list = new List<List<Point<int>>>();
    for (int i = 0; i < 9; i++) {
      List<Point<int>> singleRow = new List<Point<int>>();
      for (int j = 0; j < 9; j++) {
        Point<int> cell = new Point(j, i);
        singleRow.add(cell);
      }
      list.add(singleRow);
    }
    return list;
  }

  // Creates list of 3x3 area coordinates (Point<int>)
  List<List<Point<int>>> getAreaRegions() {
    List<List<Point<int>>> list = new List<List<Point<int>>>();

    for (int i = 0; i < 9; i += 3) {
      for (int j = 0; j < 9; j += 3) {
        list.add(getSpecificArea(i, i + 3, j, j + 3));
      }
    }

    return list;
  }


  // returns specific 3x3 area of the sudoku
  List<Point<int>> getSpecificArea(int rowStart, int rowEnd, int colStart,
      int colEnd) {
    List<Point<int>> area = new List<Point<int>>();

    for (int i = rowStart; i < rowEnd; i++) {
      for (int j = colStart; j < colEnd; j++) {
        area.add(new Point(i, j));
      }
    }
    return area;
  }


  void printSudoku(List<List<int>> sudoku) {
    for (List<int> i in sudoku) {
      print(i);
    }
    print("");
  }


  // TODO implementation
  // returns amount of possible solutions for given sudoku
  int getSudokuSolutions(List<List<int>> sudoku) {
    return 1;
  }
}