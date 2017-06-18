// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

class SudokuView {
  abstractSudoku _model;

  static int _gameTableRows = 9;
  static int _gameTableCols = 9;
  static double _gameTableWidthPercent = 90.0;
  static double _gameTableHeightPercent = 60.0;
  static int _controlTableRows = 3;
  static int _controlTableCols = 3;
  static double _controlTableHeightPercent = 25.0;

  DivElement _overlay = document.getElementById("overlay");

  DivElement _title = document.getElementById("title");

  TableElement _gameField = document.getElementById("sudokuGameField");
  TableElement _controlField = document.getElementById("sudokuControlField");


  SudokuView() {
    print("View Constructor");
    createGameTable();
    createControlTable();
  }

  void createGameTable() {
    print("Create Game Table");
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
    print("Game Table Size: " + tableSize.toString());
    _gameField.style.width = tableSize.toString() + "px";
    _gameField.style.height = tableSize.toString() + "px";

    print("Built Game Table");
  }

  int getTableSize() {
    //int tableWidth = (window.innerWidth * gameTableWidthPercent / 100).toInt();
    int tableWidth = window.innerWidth * _gameTableWidthPercent ~/ 100;
    int tableHeight = window.innerHeight * _gameTableHeightPercent ~/ 100;

    if(tableWidth <= tableHeight)
      return tableWidth;

    return tableHeight;
  }

  void createControlTable() {
    print("Create Control Table");
    TableElement table =  new TableElement();
    table.id = "control_table";

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

    int tableSize = window.innerHeight * _controlTableHeightPercent ~/ 100;
    print("Control Table Size: " + tableSize.toString());
    _controlField.style.width = tableSize.toString() + "px";
    _controlField.style.height = tableSize.toString() + "px";

    print("Built Control Table");
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
    for(TableCellElement cell in gameCells) {
      String cellID = cell.id.substring(5);
      int cellRow = int.parse(cellID.substring(0, 1));
      int cellCol = int.parse(cellID.substring(2));
      if(_model.getGameField()[cellRow][cellCol] != -1)
      cell.classes.add("fixedGameField");
    }
    _title.text = ">sudo ku";
  }


  void updateClock() {

  }

  void updateWin() {
    if(_model.isSolved())
      _title.text = "WIN";
    else
      _title.text = ">sudo ku";
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

    // Device Orientation
    var isMobile = window.matchMedia("only screen and (max-width: 760px)");
    var orientationLandscape = window.matchMedia("(orientation: landscape)");

    if(isMobile.matches) {
      print("Mobile");
      if(orientationLandscape.matches) {
        _overlay.innerHtml =
        "<h1>"
            "Please rotate Device!"
            "</h1>"
        //"<img src='\img\Logo_Hell.png' alt='Sudoku'>"
            ;

        _gameField.style.visibility = "hidden";
        _controlField.style.visibility = "hidden";
      }
      else {
        _overlay.innerHtml = "";
        _gameField.style.visibility = "visible";
        _controlField.style.visibility = "visible";
      }
    }
    else {
      print("Desktop");
      _overlay.innerHtml = "";
      _gameField.style.visibility = "visible";
      _controlField.style.visibility = "visible";
    }

    // Adjust gameTable & controlTable sizes
    int gameTableSize = getTableSize();
    print("Game Table Size: " + gameTableSize.toString());
    _gameField.style.width = gameTableSize.toString() + "px";
    _gameField.style.height = gameTableSize.toString() + "px";

    int controlTableSize = window.innerHeight * _controlTableHeightPercent ~/ 100;
    print("Control Table Size: " + controlTableSize.toString());
    _controlField.style.width = controlTableSize.toString() + "px";
    _controlField.style.height = controlTableSize.toString() + "px";
  }

  void setModel(abstractSudoku sudoku) {
    this._model = sudoku;
  }
}