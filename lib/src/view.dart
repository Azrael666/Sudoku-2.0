// Copyright (c) 2017, Kevin Joe Reif & Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

/**
 * A [SudokuView] reflects the state of the current [Sudoku]
 * to the user by interacting with the DOM tree
 */
class SudokuView {
  Sudoku _model;

  static int _gameTableRows = 9;
  static int _gameTableCols = 9;
  static double _gameTableWidthPercent = 90.0;
  static double _gameTableHeightPercent = 60.0;
  static int _controlTableRows = 3;
  static int _controlTableCols = 3;
  static double _controlTableHeightPercent = 25.0;

  DivElement _warningOverlay = document.getElementById("warningOverlay");
  DivElement _overlay = document.getElementById("overlay");
  DivElement _container = document.getElementById("container");

  DivElement _clock = document.getElementById("clock");

  TableElement _gameField = document.getElementById("sudokuGameField");
  TableElement _controlField = document.getElementById("sudokuControlField");


  SudokuView() {
    createGameTable();
    createControlTable();
  }

  void createGameTable() {
    TableElement table =  new TableElement();
    table.id = "game_table";

    for(int i = 0; i < _gameTableRows; i++) {
      TableRowElement tempRow = _gameField.addRow();
      for(int j = 0; j < _gameTableCols; j++) {
        TableCellElement tableCell = tempRow.addCell();
        tableCell.id = "Game_" + i.toString() + "_" + j.toString();
        tableCell.classes.add("GameCell");

      }
    }
    int tableSize = getTableSize();
    _gameField.style.width = tableSize.toString() + "px";
    _gameField.style.height = tableSize.toString() + "px";

  }

  int getTableSize() {
    int tableWidth = window.innerWidth * _gameTableWidthPercent ~/ 100;
    int tableHeight = window.innerHeight * _gameTableHeightPercent ~/ 100;

    if(tableWidth <= tableHeight)
      return tableWidth;

    return tableHeight;
  }


  void createControlTable() {

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

    TableRowElement row = _controlField.addRow();
    TableCellElement cell = row.addCell();
    cell.id = "Control_Hint";
    cell.classes.add("ControlCell");
    cell.text = "hint (  )";
    cell.colSpan= 3;


    int tableSize = window.innerHeight * _controlTableHeightPercent ~/ 100;
    _controlField.style.width = tableSize.toString() + "px";
    _controlField.style.height = tableSize.toString() + "px";

  }

  // Update DOM Tree
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
  
  void setControl() {
    List<TableCellElement> controlCells = document.querySelectorAll(".ControlCell");
    for(TableCellElement cell in controlCells) {
      if(cell.text == _model.getControlValue().toString())
        updateControl(cell);
      break;
    }
  }

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

  void initialUpdate() {
    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");

    List<List<int>> gameField = _model.getGameField();
    List<List<Colors>> colors = _model.getColors();
    List<List<Sides>> sides = _model.getSides();

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


  void updateClock(Duration clockCount) {
    int hours = clockCount.inHours % 24;
    int minutes = clockCount.inMinutes % 60;
    int seconds = clockCount.inSeconds % 60;
    _clock.text = hours.toString() + ":" + minutes.toString() + ":" + seconds.toString();
  }

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

  void resize() {

    _container.style.height = "100%";
    _container.style.width = "100%";

    // Device Orientation
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

    // Adjust gameTable & controlTable sizes
    int gameTableSize = getTableSize();
    _gameField.style.width = gameTableSize.toString() + "px";
    _gameField.style.height = gameTableSize.toString() + "px";

    int controlTableSize = window.innerHeight * _controlTableHeightPercent ~/ 100;
    _controlField.style.width = controlTableSize.toString() + "px";
    _controlField.style.height = controlTableSize.toString() + "px";
  }

  void setModel(Sudoku sudoku) {
    this._model = sudoku;
  }
}