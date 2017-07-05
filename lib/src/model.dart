// Copyright (c) 2017, Kevin Joe Reif & Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

/**
 * Border types for cell border of html table cells
 */
enum BorderType {THICK,THIN}

/**
 * Color types for html table cells
 */
enum Colors {COLOR_STANDARD, COLOR_STANDARD_DARK, COLOR_HIGHLIGHTED, COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6, COLOR_7, COLOR_8, COLOR_9}

/**
 * Game types for generating different sudokus
 */
enum GameTypes {STANDARD_SUDOKU, X_SUDOKU, HYPER_SUDOKU, MIDDELPOINT_SUDOKU, COLOR_SUDOKU, NONOMINO_SUDOKU}


/**
 * Defines a [Sudoku] of this game.
 * A [Sudoku] has different 2D lists for specific information about each sudoku cell.
 * A [Sudoku] has a control value, which displays the currently selected input number or -2 for the "hint" button.
 * A [Sudoku] has a hint counter value, which shows the remaining amount of hints.
 */
class Sudoku {
  /**
   * Represents the solved sudoku
   */
  List<List<int>> _gameFieldSolved;

  /**
   * Represents the currently displayed sudoku.
   */
  List<List<int>> _gameField;

  /**
   * Represents the available fields, a user has access to.
   */
  List<List<bool>> _userInput;

  /**
   * Represents the colors of each field.
   */
  List<List<Colors>> _colors;

  /**
   * Represents the sides of each field.
   */
  List<List<Sides>> _sides;

  /**
   * Currently selected input value.
   */
  int _controlValue;

  /**
   * Remaining hints.
   */
  int _hintCounter;

  /**
   * Constructor to create a [Sudoku] object.
   */
  Sudoku() {
    _controlValue = 1;
    _hintCounter = 5;
  }

  /**
   * Checks if the player has solved the sudoku correct.
   */
  bool isSolved() {
    for(int i = 0; i < _gameFieldSolved.length; i++) {
      for(int j = 0; j < _gameFieldSolved[0].length; j++) {
        if(_gameFieldSolved[i][j] != _gameField[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * Sets a specific field according to _controlValue.
   */
  setGameCell(int row, int col) {
    // Check if user has access to that field
    if(_userInput[row][col]) {
      // Specific case for hint button
      if(_controlValue == -2) {
        if(_hintCounter > 0) {
          _gameField[row][col] = _gameFieldSolved[row][col];
          _hintCounter--;
        }
      }
      // Delete current value
      else if (_gameField[row][col] == _controlValue)
        _gameField[row][col] = -1;

      // Set field to current control value
      else
        _gameField[row][col] = _controlValue;
    }

  }

  /**
   * Sets internal control value.
   */
  setControlValue(String value) {
    if(value == "hint"){
      _controlValue = -2;
      return;
    }

    int controlValue = int.parse(value);
    this._controlValue = controlValue;
  }

  /**
   * Setter for _gameFieldSolved.
   */
  setGameFieldSolved(List<List<int>> gameField){
    this._gameFieldSolved = gameField;
  }

  /**
   * Getter for _gameField.
   */
  List<List<int>> getGameField() {
    return this._gameField;
  }

  /**
   * Setter for _gameField.
   */
  setGameField (List<List<int>> gameField){
    this._gameField = gameField;
  }

  /**
   * Setter for _userInput.
   */
  setUserInput(List<List<bool>> userInput){
    this._userInput = userInput;
  }

  /**
   * Getter for _colors.
   */
  List<List<Colors>> getColors() {
    return this._colors;
  }

  /**
   * Setter for _colors.
   */
  setColors(List<List<Colors>> colors) {
    this._colors = colors;
  }

  /**
   * Getter for _sides.
   */
  List<List<Sides>> getSides() {
    return this._sides;
  }

  /**
   * Setter for _sides.
   */
  setSides(List<List<Sides>> sides){
    this._sides= sides;
  }

  int getControlValue() {
    return this._controlValue;
  }

  /**
   * Getter for _hintCounter.
   */
  int getHintCounter() {
    return this._hintCounter;
  }

}

/**
 * Defines a [Sides] object for an html table cell.
 */
class Sides{
  BorderType left,bottom,right,top;

  int row,col;

  toString() =>"left: $left, bottom:$bottom, right:$right, top:$top ($row,$col)";
}


/**
 * A [SudokuGenerator] has a list of json level files
 * A [SudokuGenerator] has a Random for generating random-numbers
 * A [SudokuGenerator] has different position lists, used for generating sudokus
 */
class SudokuGenerator {

  /**
   * String representation of json level files.
   */
  List<String> _jsonLevelFiles;

  /**
   * Random for generating random numbers.
   */
  Random _random = new Random.secure();

  /**
   * List of middlepoint positions.
   * Used for generating middlepoint-sudokus.
   */
  List<Point<int>> _middlepoints;

  /**
   * List of diagonal positions.
   * Used for generating x-sudokus.
   */
  List<List<Point<int>>> _diagonalPoints;

  /**
   * List of hyper square positions.
   * Used for generating hyper-sudokus.
   */
  List<List<Point<int>>> _hyperPoints;

  /**
   * List of color positions.
   * Used for generating color-sudokus.
   */
  List<List<Point<int>>> _colorPoints;

  /**
   * Constructor to create a [SudokuGenerator] object.
   */
  SudokuGenerator() {

    // Initialize middlepoint positions
    _middlepoints = new List<Point<int>>();
    for (int i = 1; i <= 7; i = i + 3) {
      for (int j = 1; j <= 7; j = j + 3) {
        _middlepoints.add(new Point(i, j));
      }
    }

    // Initialize diagonal positions
    _diagonalPoints = new List<List<Point<int>>>();
    List<Point<int>> firstDiagonal = new List<Point<int>>();
    List<Point<int>> secondDiagonal = new List<Point<int>>();
    for (int i = 0; i < 9; i++) {
      // First diagonal from top left to bottom right
      Point<int> firstPoint = new Point(i, i);
      firstDiagonal.add(firstPoint);

      // Second diagonal from bottom left to top right
      Point<int> secondPoint = new Point(i, 8 - i);
      secondDiagonal.add(secondPoint);
    }
    _diagonalPoints.add(firstDiagonal);
    _diagonalPoints.add(secondDiagonal);


    // Initialize hyper square positions
    _hyperPoints = new List<List<Point<int>>>();

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
    _hyperPoints.add(hyperSquare1);
    _hyperPoints.add(hyperSquare2);
    _hyperPoints.add(hyperSquare3);
    _hyperPoints.add(hyperSquare4);


    // Initialize color positions
    _colorPoints = new List<List<Point<int>>>();
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
    _colorPoints.add(Color1);
    _colorPoints.add(Color2);
    _colorPoints.add(Color3);
    _colorPoints.add(Color4);
    _colorPoints.add(Color5);
    _colorPoints.add(Color6);
    _colorPoints.add(Color7);
    _colorPoints.add(Color8);
    _colorPoints.add(Color9);


    // Load jsonFiles for nonomino sudokus
    _jsonLevelFiles = new List<String>();

    String folder = "nonomino";
    for (int i = 1; i < 4; i++) {
      String path = "level/" + folder + "/level" + i.toString() + ".json";
      loadJsonFiles(path);
    }
  }

  /**
   * Asynchronously loads jsonFiles for nonomino sudokus
   */
  loadJsonFiles(String path) async {
    await HttpRequest.getString(path).then((content) =>
        addLevelToList(content));
  }

  /**
   * Adds given level to _jsonLevelFiles list
   */
  void addLevelToList(String content) {
    _jsonLevelFiles.add(content);
  }

  /**
   * Returns copy of given List<List<int>> list.
   */
  List<List<int>> copyList(List<List<int>> list) {
    List<List<int>> ret = new List<List<int>>();

    for (int i = 0; i < list.length; i++) {
      List<int> tempList = new List<int>();

      for (int j = 0; j < list[i].length; j++) {
        tempList.add(list[i][j]);
      }
      ret.add(tempList);
    }
    return ret;
  }

  /**
   * Create a new [Sudoku] according to [gameType].
   */
  Sudoku newSudoku(GameTypes gameType) {
    Sudoku sudoku = new Sudoku();

    // Create new solved sudoku
    List<List<int>> gameFieldSolved = generateGame(gameType);

    // Delete fields
    List<List<int>> gameField = createUserSudoku(gameFieldSolved);

    // Set empty fields as userInput
    List<List<bool>>userInput = createUserInputValues(gameField, -1);

    sudoku.setGameFieldSolved(gameFieldSolved);
    sudoku.setGameField(gameField);
    sudoku.setUserInput(userInput);


    // From this point until the end of this method author: Kevin Joe Reif

    // Create Colors
    List<List<Colors>> colors = new List<List<Colors>>(gameFieldSolved.length);

    for(int i = 0; i < gameFieldSolved.length; i++) {
      List<Colors> colorRow  = new List<Colors>(gameFieldSolved[0].length);
      for(int j = 0; j < gameFieldSolved[0].length; j++) {

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

    if(gameType == GameTypes.COLOR_SUDOKU){
      List<Colors> list = [Colors.COLOR_1,Colors.COLOR_2,Colors.COLOR_3,Colors.COLOR_4,Colors.COLOR_5,Colors.COLOR_6,Colors.COLOR_7,Colors.COLOR_8,Colors.COLOR_9];
      list.shuffle();

      for(int i=0;i<3;i++){
        for(int i1=0;i1<3;i1++){

          for(int i2=0;i2<3;i2++){
            for(int i3=0;i3<3;i3++){
              colors[i*3+i2][i1*3+i3] = list[i2*3+i3];
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

  /**
   * Randomly removes numbers from sudoku
   */
  List<List<int>> createUserSudoku(List<List<int>> sudoku) {
    var userSudoku = copyList(sudoku);

    for (int i = 0; i < 20; i++) {
      int row = _random.nextInt(9);
      int col = _random.nextInt(9);
      userSudoku[row][col] = -1;
    }
    return userSudoku;
  }

  /**
   * Returns new bool list, where every entry is true,
   * when the corresponding field in sudoku is empty.
   */
  List<List<bool>> createUserInputValues(List<List<int>> sudoku, int emptyValue) {
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


  /**
   * Calls different functions for generating a new sudoku
   * or loading a new sudoku from json file.
   */
  Sudoku newGame(GameTypes gameType) {

    if(gameType == GameTypes.NONOMINO_SUDOKU)
      return newNonominoSudoku();
    else
      return newSudoku(gameType);

  }

  /**
   * Randomly loads one of the available nonomino sudokus from
   * previously loaded json files.
   */
  Sudoku newNonominoSudoku() {
    int random = _random.nextInt(3);
    Map level = JSON.decode(_jsonLevelFiles[random]);

    Sudoku sudoku = new Sudoku();

    List<List<int>> gameFieldSolved = level["fields"];
    List<List<bool>> userInput = createUserInputValues(level["empty"], 1);
    List<List<int>> gameField = getGameFieldFromFile(gameFieldSolved, userInput);

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


    // From this point until end of method - author: Kevin Joe Reif

    // Set sides
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
    sudoku.setColors(colors);

    return sudoku;
  }

  /**
   * Generates a new [Sudoku] game according to [gameType].
   */
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

    // Start stopwatch
    Stopwatch timeStopwatch = new Stopwatch();
    timeStopwatch.start();

    bool found = false;
    do {
      Stopwatch cancelTimer = new Stopwatch();
      cancelTimer.start();

      // Try to generate a new game
      found = createGame(sudoku, sets, gameType, cancelTimer);

      // Abort generation after 10s, because it's likely to freeze
      // the site for several minutes if there is no solution after a few seconds
    } while (!found && timeStopwatch.elapsedMilliseconds < 10000);

    if (found) {
      return sudoku;
    } else {
      return null;
    }
  }

  /**
   * Backtracking algorithm that creates a valid & solved sudoku.
   */
  bool createGame(List<List<int>> sudoku, List<List<List<int>>> sets, GameTypes gameType, Stopwatch cancelTimer) {

    // If there is no solution after 1s, abort this attempt
    // Generally generation time, except for hyper-sudokus, is way < 1s
    if (cancelTimer.elapsedMilliseconds > 1000)
      return false;


    // Find next empty position
    Point<int> nextPosition = findNextPosition(sudoku);

    // Return true if the sudoku board is complety filled
    if (nextPosition != null) {
      int positionX = nextPosition.x;
      int positionY = nextPosition.y;

      // Get set with possible numbers for current position
      List<int> positionNumberSet = new List<int>.from(sets[positionX][positionY]);

      int positionNumberSetSize = positionNumberSet.length;

      // Continue, if there is a possible number for the current position
      if (positionNumberSetSize > 0) {

        // Create new numbers 0 - positionNumberSetSize
        List<int> rand = new List<int>();
        for (int i = 0; i < positionNumberSetSize; i++) {
          rand.add(i);
        }

        // Shuffle numbers for random order
        rand.shuffle();

        // Check every possible number for this position
        for (int i = 0; i < positionNumberSetSize; i++) {

          // Get random possible number from set
          int index = rand.removeAt(0);
          int nextNumber = positionNumberSet[index];

          // Fill number in current position field of sudoku
          sudoku[positionX][positionY] = nextNumber;

          // Remove chosen number from all sets of position's row, column & 3x3 area
          List<List<List<int>>> nextSets = removeNumberFromSets(positionX, positionY, nextNumber, sets, gameType);

          // Recursive call for finding next number
          if (createGame(sudoku, nextSets, gameType, cancelTimer)) {
            return true;
          } else {
            // If there was no possible number, undo change of sudoku field
            sudoku[positionX][positionY] = -1;
            continue;
          }
        }
        return false;
      } else
        return false;
    } else {
      return true;
    }
  }

  /**
   * Returns point, that represents next empty position of [sudoku]
   * or null if there is no empty position in [sudoku].
   */
  Point<int> findNextPosition(List<List<int>> sudoku) {

    // top left to bottom right
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (sudoku[i][j] == -1)
          return new Point(i, j);
      }
    }

    return null;
  }

  /**
   * Removes number from sets, according to [gameType] restrictions.
   */
  List<List<List<int>>> removeNumberFromSets(int x, int y, int number, List<List<List<int>>> sets, GameTypes gameType) {

    // Complete copy of given sets
    List<List<List<int>>> nextSets = new List<List<List<int>>>();

    // For each row
    for (int i = 0; i < sets.length; i++) {
      List<List<int>> nextRow = copyList(sets[i]);

      nextSets.add(nextRow);
    }


    // Removal

    // Rows & Cols
    removeNumberFromRowsAndCols(x, y, number, nextSets);

    // 3x3 area
    if (gameType != GameTypes.NONOMINO_SUDOKU)
      removeNumberFrom3x3Area(x, y, number, nextSets);

    // Diagonals
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

  /**
   * Removes number from all sets in number's row & column
   */
  void removeNumberFromRowsAndCols(int x, int y, int number, List<List<List<int>>> sets) {
    for (int i = 0; i < 9; i++) {
      int rowIndex = sets[i][y].indexOf(number);
      if (rowIndex >= 0)
        sets[i][y].removeAt(rowIndex);

      int colIndex = sets[x][i].indexOf(number);
      if (colIndex >= 0)
        sets[x][i].removeAt(colIndex);
    }
  }

  /**
   * Removes number from all sets in number's 3x3 area
   */
  void removeNumberFrom3x3Area(int x, int y, int number, List<List<List<int>>> sets) {
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

  /**
   * If number is in diagonal position,
   * removes number from all sets diagonal positions
   */
  void removeNumberFromDiagonals(int x, int y, int number, List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    for (List<Point<int>> diagonal in _diagonalPoints) {
      if (diagonal.contains(positionPoint)) {
        for (Point<int> point in diagonal) {
          int cellIndex = sets[point.x][point.y].indexOf(number);
          if (cellIndex >= 0)
            sets[point.x][point.y].removeAt(cellIndex);
        }
      }
    }
  }

  /**
   * If number is in hyper square position,
   * removes number from all sets in hyper square positions
   */
  void removeNumberFromHyperSquares(int x, int y, int number, List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    for (List<Point<int>> hyper in _hyperPoints) {
      if (hyper.contains(positionPoint)) {
        for (Point<int> point in hyper) {
          int cellIndex = sets[point.x][point.y].indexOf(number);
          if (cellIndex >= 0)
            sets[point.x][point.y].removeAt(cellIndex);
        }
      }
    }
  }

  /**
   * If number is in middlepoint position,
   * removes number from all sets in middlepoint positions
   */
  void removeNumberFromMiddlepoints(int x, int y, int number, List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    if (_middlepoints.contains(positionPoint)) {
      for (Point<int> point in _middlepoints) {
        int cellIndex = sets[point.x][point.y].indexOf(number);
        if (cellIndex >= 0)
          sets[point.x][point.y].removeAt(cellIndex);
      }
    }
  }

  /**
   * If number is in color position,
   * removes number from all sets in color positions
   */
  void removeNumberFromColors(int x, int y, int number, List<List<List<int>>> sets) {
    Point<int> positionPoint = new Point(x, y);
    for (List<Point<int>> color in _colorPoints) {
      if (color.contains(positionPoint)) {
        for (Point<int> point in color) {
          int cellIndex = sets[point.x][point.y].indexOf(number);
          if (cellIndex >= 0)
            sets[point.x][point.y].removeAt(cellIndex);
        }
      }
    }
  }



  /**
   * Returns list of available fields according to given [userInputValues] found in json file.
   */
  List<List<int>> getGameFieldFromFile(List<List<int>> sudokuSolved, List<List<bool>> userInputValues) {
    List<List<int>> gameField = copyList(sudokuSolved);
    for (int i = 0; i < userInputValues.length; i++) {
      for (int j = 0; j < userInputValues[0].length; j++) {
        if (userInputValues[i][j])
          gameField[i][j] = -1;
      }
    }
    return gameField;
  }

}