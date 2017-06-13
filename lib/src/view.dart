// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

class SudokuView {
  SudokuGame model;

  static int gameTableRows = 9;
  static int gameTableCols = 9;
  static double gameTableWidthPercent = 90.0;
  static double gameTableHeightPercent = 60.0;
  static int controlTableRows = 3;
  static int controlTableCols = 3;
  static double controlTableHeightPercent = 25.0;

  DivElement overlay = document.getElementById("overlay");

  DivElement title = document.getElementById("title");

  TableElement gameField = document.getElementById("sudokuGameField");
  TableElement controlField = document.getElementById("sudokuControlField");


  SudokuView(SudokuGame model) {
    print("View Constructor");
    this.model = model;
    createGameTable();
    createControlTable();
  }

  void createGameTable() {
    print("Create Game Table");
    TableElement table =  new TableElement();
    table.id = "game_table";

    for(int i = 0; i < gameTableRows; i++) {
      TableRowElement tempRow = gameField.addRow();
      for(int j = 0; j < gameTableCols; j++) {
        TableCellElement tableCell = tempRow.addCell();
        tableCell.id = "Game_" + i.toString() + "_" + j.toString();
        tableCell.classes.add("GameCell");
      }
    }
    int tableSize = getTableSize();
    print("Game Table Size: " + tableSize.toString());
    gameField.style.width = tableSize.toString() + "px";
    gameField.style.height = tableSize.toString() + "px";

    print("Built Game Table");
  }

  int getTableSize() {
    //int tableWidth = (window.innerWidth * gameTableWidthPercent / 100).toInt();
    int tableWidth = window.innerWidth * gameTableWidthPercent ~/ 100;
    int tableHeight = window.innerHeight * gameTableHeightPercent ~/ 100;

    if(tableWidth <= tableHeight)
      return tableWidth;

    return tableHeight;
  }

  void createControlTable() {
    print("Create Control Table");
    TableElement table =  new TableElement();
    table.id = "control_table";

    int count = 1;
    for(int i = 0; i < controlTableRows; i++) {
      TableRowElement tempRow = controlField.addRow();
      for(int j = 0; j < controlTableCols; j++) {
        TableCellElement tableCell = tempRow.addCell();
        tableCell.id = "Control_" + i.toString() + "_" + j.toString();
        tableCell.classes.add("ControlCell");
        tableCell.text = count.toString();
        if(i == 0 && j == 0)
          tableCell.classes.add("selectedControl");
        count++;
      }
    }

    int tableSize = window.innerHeight * controlTableHeightPercent ~/ 100;
    print("Control Table Size: " + tableSize.toString());
    controlField.style.width = tableSize.toString() + "px";
    controlField.style.height = tableSize.toString() + "px";

    print("Built Control Table");
  }

  // Update DOM Tree
  void update() {
    List<List<int>> gameField = model.getGameField();

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
      if(model.getGameField()[cellRow][cellCol] != -1)
      cell.classes.add("fixedGameField");
    }
    title.text = ">sudo ku";
  }

  void updateOrientation() {
    if(window.innerHeight < window.innerWidth) {
      overlay.innerHtml =
      "<h1>"
          "Please rotate Device!"
          "</h1>";
      gameField.style.visibility = "hidden";
      controlField.style.visibility = "hidden";
    }
    else {
      overlay.innerHtml = "";
      gameField.style.visibility = "visible";
      controlField.style.visibility = "visible";
    }
  }

  void updateWin() {
    if(model.checkSolved())
      title.text = "WIN";
    else
      title.text = ">sudo ku";
  }

  void showHelp(bool help) {
    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");
    for(TableCellElement cell in gameCells) {
      String cellID = cell.id.substring(5);
      int cellRow = int.parse(cellID.substring(0, 1));
      int cellCol = int.parse(cellID.substring(2));
      if (help) {
        if (model.getGameField()[cellRow][cellCol] == model.getControlValue())
          cell.classes.add("highlighted");
        else if (cell.classes.contains("highlighted"))
          cell.classes.remove("highlighted");
      }
      else
        cell.classes.remove("highlighted");
    }
  }

  void resize() {
    int gameTableSize = getTableSize();
    print("Game Table Size: " + gameTableSize.toString());
    gameField.style.width = gameTableSize.toString() + "px";
    gameField.style.height = gameTableSize.toString() + "px";

    int controlTableSize = window.innerHeight * controlTableHeightPercent ~/ 100;
    print("Control Table Size: " + controlTableSize.toString());
    controlField.style.width = controlTableSize.toString() + "px";
    controlField.style.height = controlTableSize.toString() + "px";
  }
}