// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

const orientationTriggerSpeed = const Duration(milliseconds: 100);

class SudokuController {
  
  final overlay = document.getElementById("overlay");
  final newGameButton = document.getElementById("newGameButton");
  final helpButton = document.getElementById("helpButton");
  bool help = false;
  Timer orientationTrigger;

  SudokuGame game;

  SudokuView view;

  SudokuController () {
    game = new SudokuGame();
    view = new SudokuView(game);

    addControlStuff();
  }

  addControlStuff() {
    print("Add Control Stuff");

    orientationTrigger = new Timer.periodic(orientationTriggerSpeed, (_) => orientation());
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

  void orientation() {
    view.updateOrientation();
  }

  void windowResize(e) {
    view.resize();
  }

  void newGame(e) {
    game.newGame();
    view.update();
    view.initialUpdate();
  }

  void helpFunc(e) {
    help = !help;
    view.showHelp(help);

  }

  void gameCell(TableCellElement cell) {
    String cellID = cell.id.substring(5);
    int cellRow = int.parse(cellID.substring(0, 1));
    int cellCol = int.parse(cellID.substring(2));
    game.setGameCell(cellRow, cellCol);

    view.update();
    view.showHelp(help);

    view.updateWin();
  }

  void controlCell(TableCellElement cell) {

    game.setControlValue(cell.text);
    view.updateControl(cell);
    view.showHelp(help);
  }
}