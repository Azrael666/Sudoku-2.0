// Copyright (c) 2017, Kevin Joe Reif & Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

/**
 * A [SudokuView] reflects the state of the current [Sudoku]
 * to the user by interacting with the DOM tree.
 */
class SudokuView {

  /**
   * Reference to the current [Sudoku].
   */
  Sudoku _model;

  /**
   * Number of game table rows.
   */
  static int _gameTableRows = 9;

  /**
   * Number of game table columns.
   */
  static int _gameTableCols = 9;

  /**
   * Width percentage that the game table should have.
   */
  static double _gameTableWidthPercent = 90.0;

  /**
   * Height percentage that the game table should have.
   */
  static double _gameTableHeightPercent = 60.0;

  /**
   * Number of control table rows.
   */
  static int _controlTableRows = 3;

  /**
   * Number of control table columns.
   */
  static int _controlTableCols = 3;

  /**
   * Height percentage that the control table should have.
   */
  static double _controlTableHeightPercent = 25.0;

  /**
   * Element with id 'warningOverlay' of the DOM tree.
   * Used to display warning overlays.
   * (e.g. device rotation message)
   */
  DivElement _warningOverlay = document.getElementById("warningOverlay");

  /**
   * Element with id 'overlay' of the DOM tree.
   * Used to display overlay forms.
   * (e.g. Win overlay or game type selection)
   */
  DivElement _overlay = document.getElementById("overlay");

  /**
   * Element with id 'container' of the DOM tree.
   * Used for resizing.
   */
  DivElement _container = document.getElementById("container");

  /**
   * Element with id 'clock' of the DOM tree.
   * Used for showing the elapsed playing time.
   */
  DivElement _clock = document.getElementById("clock");

  /**
   * Element with id 'sudokuGameField' of the DOM tree.
   * Used for displaying & updating the state of the [Sudoku] game.
   */
  TableElement _gameField = document.getElementById("sudokuGameField");

  /**
   * Element with id 'sudokuControlField' of the DOM tree.
   * Used for displaying & updating the control elements.
   */
  TableElement _controlField = document.getElementById("sudokuControlField");

  /**
   * Constructor to create a [SudokuView] object.
   */
  SudokuView() {
    createGameTable();
    createControlTable();
  }

  /**
   * Initially creates a html table which represents the fields of an [Sudoku].
   */
  void createGameTable() {

    // Generating table
    for(int i = 0; i < _gameTableRows; i++) {
      TableRowElement tempRow = _gameField.addRow();
      for(int j = 0; j < _gameTableCols; j++) {
        TableCellElement tableCell = tempRow.addCell();
        tableCell.id = "Game_" + i.toString() + "_" + j.toString();
        tableCell.classes.add("GameCell");

      }
    }

    // Set width & height
    int tableSize = getTableSize();
    _gameField.style.width = tableSize.toString() + "px";
    _gameField.style.height = tableSize.toString() + "px";

  }

  /**
   * Calculates table size for quadratic table
   */
  int getTableSize() {
    int tableWidth = window.innerWidth * _gameTableWidthPercent ~/ 100;
    int tableHeight = window.innerHeight * _gameTableHeightPercent ~/ 100;

    if(tableWidth <= tableHeight)
      return tableWidth;

    return tableHeight;
  }

  /**
   * Initially creates a html table which represents the control elements.
   */
  void createControlTable() {

    // Generating table
    int count = 1;
    for(int i = 0; i < _controlTableRows; i++) {
      TableRowElement tempRow = _controlField.addRow();
      for(int j = 0; j < _controlTableCols; j++) {
        TableCellElement tableCell = tempRow.addCell();
        tableCell.id = "Control_" + i.toString() + "_" + j.toString();
        tableCell.classes.add("ControlCell");
        tableCell.text = count.toString();

        if(i == 0 && j == 0)
          tableCell.classes.add("selectedControl");
        count++;
      }
    }

    // Add hint button
    TableRowElement row = _controlField.addRow();
    TableCellElement cell = row.addCell();
    cell.id = "Control_Hint";
    cell.classes.add("ControlCell");
    cell.text = "hint (  )";
    cell.colSpan= 3;

    // Set width & height
    int tableSize = window.innerHeight * _controlTableHeightPercent ~/ 100;
    _controlField.style.width = tableSize.toString() + "px";
    _controlField.style.height = tableSize.toString() + "px";

  }

  /**
   * Updates game field according to [Sudoku] state.
   */
  void update() {
    List<List<int>> gameField = _model.getGameField();

    // Update GameField
    for(int i = 0; i < 9; i++) {
      for(int j = 0; j < 9; j++) {
        TableCellElement cell = document.getElementById("Game_" + i.toString() + "_" + j.toString());
        if(gameField[i][j] == -1)
          cell.text = "";
        else
          cell.text = gameField[i][j].toString();
      }
    }

    // Update hint value
    TableCellElement controlHint = document.getElementById("Control_Hint");
    controlHint.text = "hint ( " + _model.getHintCounter().toString() + " )";
  }

  /**
   * Initially highlights control element at the start of a new game.
   */
  void setControl() {
    List<TableCellElement> controlCells = document.querySelectorAll(".ControlCell");
    for(TableCellElement cell in controlCells) {
      if(cell.text == _model.getControlValue().toString())
        updateControl(cell);
      break;
    }
  }

  /**
   * Updates highlighting of control elements.
   */
  void updateControl(TableCellElement actualCell) {
    List<TableCellElement> controlCells = document.querySelectorAll(".ControlCell");
    for(TableCellElement cell in controlCells) {
      if (cell.classes.contains("selectedControl")) {
        cell.classes.remove("selectedControl");
        break;
      }
    }
    actualCell.classes.add("selectedControl");
  }

  /**
   * Initializes the view at the start of a new [Sudoku] game.
   */
  void initialUpdate() {
    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");

    List<List<int>> gameField = _model.getGameField();
    List<List<Colors>> colors = _model.getColors();
    List<List<Sides>> sides = _model.getSides();

    // Set initially fixed fields and colors of fields
    for(TableCellElement cell in gameCells) {
      cell.classes.clear();
      cell.classes.add("GameCell");
      cell.classes.add("COLOR_STANDARD");

      String cellID = cell.id.substring(5);
      int cellRow = int.parse(cellID.substring(0, 1));
      int cellCol = int.parse(cellID.substring(2));

      if(gameField[cellRow][cellCol] != -1)
        cell.classes.add("fixedGameField");

      String color = colors[cellRow][cellCol].toString();
      color = color.substring(7);
      cell.classes.add(color);

      // Set game field cell borders
      if(sides != null){
        Sides s = sides[cellRow][cellCol];

        cell.dataset.putIfAbsent("col", ()=>"$cellCol");
        cell.dataset.putIfAbsent("row", ()=>"$cellRow");
        cell.dataset.putIfAbsent("sides", ()=>"$s");

        cell.style.borderLeft = (s.left==BorderType.THIN)?"inset":"solid";
        cell.style.borderBottom = (s.bottom==BorderType.THIN)?"inset":"solid";
        cell.style.borderRight = (s.right==BorderType.THIN)?"inset":"solid";
        cell.style.borderTop = (s.top==BorderType.THIN)?"inset":"solid";

      }

    }

  }

  /**
   * Updates the play time clock.
   */
  void updateClock(Duration clockCount) {
    int hours = clockCount.inHours % 24;
    int minutes = clockCount.inMinutes % 60;
    int seconds = clockCount.inSeconds % 60;
    _clock.text = hours.toString() + ":" + minutes.toString() + ":" + seconds.toString();
  }

  /**
   * Shows the overlay with images of
   * available game types to start a new game.
   */
  void updateNewGame() {
    _overlay.innerHtml =
    "<div id='newGame'>"
      "<table id='newGameTable'>"
        "<tr>"
          "<td>"
            "<img src='img/Standard-Sudoku.png' id ='newStandardSudoku' class='newGame' alt='Standard-Sudoku'>"
          "</td>"
          "<td>"
            "<img src='img/X-Sudoku.png' id ='newXSudoku' class='newGame' alt='X-Sudoku'>"
          "</td>"
        "</tr>"
        "<tr>"
          "<td>"
            "<img src='img/Hyper-Sudoku.png' id ='newHyperSudoku' class='newGame' alt='Hyper-Sudoku'>"
          "</td>"
          "<td>"
            "<img src='img/Middlepoint-Sudoku.png' id ='newMiddlepointSudoku' class='newGame' alt='Middlepoint-Sudoku'>"
          "</td>"
          "</tr>"
          "<tr>"
            "<td>"
              "<img src='img/Color-Sudoku.png' id ='newColorSudoku' class='newGame' alt='Color-Sudoku'>"
            "</td>"
            "<td>"
             "<img src='img/Nonomino-Sudoku.png' id ='newNonominoSudoku' class='newGame' alt='Nonomino-Sudoku'>"
            "</td>"
          "</tr>"
      "</table>"
    "</div>"
    ;
  }

  /**
   * Shows win overlay when the player has solved a [Sudoku] correct.
   */
  void updateWin(Duration time) {
    int hours = time.inHours % 24;
    int minutes = time.inMinutes % 60;
    int seconds = time.inSeconds % 60;

    _overlay.innerHtml =
    "<div id='win'>"
      "<p>"
        "You have solved the sudoku in"
      "<p>"
      "<p>"
      "Hours: " + hours.toString() + " Minutes: " + minutes.toString() + " Seconds: " + seconds.toString();
      "<p>"
    "</div>";
  }

  /**
   * Shows or hides help functionality according to [help].
   * Highlights all numbers that match the currently selected control value.
   */
  void showHelp(bool help) {
    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");
    for(TableCellElement cell in gameCells) {
      String cellID = cell.id.substring(5);
      int cellRow = int.parse(cellID.substring(0, 1));
      int cellCol = int.parse(cellID.substring(2));
      if (help) {
        if (_model.getGameField()[cellRow][cellCol] == _model.getControlValue())
          cell.classes.add("highlighted");
        else if (cell.classes.contains("highlighted"))
          cell.classes.remove("highlighted");
      }
      else
        cell.classes.remove("highlighted");
    }
  }

  /**
   * Resizes the container element, that contains all game elements
   * according to current window size.
   * If device is in landscape orientation, is the only screen
   * and has maximum of 760px screen-width, an warning overlay
   * is shown that tells the player to rotate the device.
   */
  void resize() {

    // Update of container size
    _container.style.height = "100%";
    _container.style.width = "100%";

    // Device orientation overlay
    var isMobile = window.matchMedia("only screen and (max-width: 760px)");
    var orientationLandscape = window.matchMedia("(orientation: landscape)");

    if(isMobile.matches) {
      if(orientationLandscape.matches) {
        _warningOverlay.innerHtml =
        "<h1>"
            "Please rotate device!"
        "</h1>"
        "<img src='img/Logo_Hell.png' id='logo' class='logo' alt='Sudoku'>"
        ;

        _container.style.display = "none";

      }
      else {
        _warningOverlay.innerHtml = "";
        _container.style.display = "initial";

      }
    }
    else {

      _warningOverlay.innerHtml = "";
      _container.style.display = "initial";

    }

    // Adjust game table size
    int gameTableSize = getTableSize();
    _gameField.style.width = gameTableSize.toString() + "px";
    _gameField.style.height = gameTableSize.toString() + "px";

    // Adjust control table size
    int controlTableSize = window.innerHeight * _controlTableHeightPercent ~/ 100;
    _controlField.style.width = controlTableSize.toString() + "px";
    _controlField.style.height = controlTableSize.toString() + "px";
  }

  /**
   * Sets the internal model to a new [Sudoku].
   */
  void setModel(Sudoku sudoku) {
    this._model = sudoku;
  }
}