// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

const clockTriggerSpeed = const Duration(milliseconds: 1000);

class SudokuController {
  
  final overlay = document.getElementById("overlay");
  final newGameButton = document.getElementById("newGameButton");
  final helpButton = document.getElementById("helpButton");
  bool help = false;
  Timer orientationTrigger;
  Timer clockTrigger;
  int clockCount = 0;

  SudokuGameGenerator model;

  SudokuView view;

  SudokuController () {
    model = new SudokuGameGenerator();
    view = new SudokuView();

    addControlStuff();
    print(window.navigator.userAgent);
  }

  addControlStuff() {
    print("Add Control Stuff");

    clockTrigger = new Timer.periodic(clockTriggerSpeed, (_) => clock());

    newGameButton.addEventListener('click', newGame);
    helpButton.addEventListener('click', helpFunc);

    window.addEventListener('resize', windowResize);

    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");
    for(TableCellElement cell in gameCells) {
      cell.addEventListener('click',
      (event) => gameCell(cell));
    }

    List<TableCellElement> controlCells = document.querySelectorAll(".ControlCell");
    for(TableCellElement cell in controlCells) {
      cell.addEventListener('click',
              (event) => controlCell(cell));
    }
  }

  void clock() {
    clockCount++;
    view.updateClock();
  }

  void windowResize(e) {
    view.resize();
  }

  void newGame(e) {
    model.newGame();
    view.setModel(model.newGame());
    view.initialUpdate();
    view.update();
  }

  void helpFunc(e) {
    help = !help;
    view.showHelp(help);

  }

  void gameCell(TableCellElement cell) {
    String cellID = cell.id.substring(5);
    int cellRow = int.parse(cellID.substring(0, 1));
    int cellCol = int.parse(cellID.substring(2));
    model.setGameCell(cellRow, cellCol);

    view.update();
    view.showHelp(help);

    view.updateWin();
  }

  void controlCell(TableCellElement cell) {

    model.setControlValue(cell.text);
    view.updateControl(cell);
    view.showHelp(help);
  }
}