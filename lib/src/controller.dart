// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

const clockTriggerSpeed = const Duration(milliseconds: 1000);

class SudokuController {
  
  final _overlay = document.getElementById("overlay");
  final _newGameButton = document.getElementById("newGameButton");
  final _helpButton = document.getElementById("helpButton");
  bool _help = false;
  Timer _clockTrigger;
  int _clockCount = 0;

  SudokuGameGenerator _model;

  SudokuView _view;

  SudokuController () {
    _model = new SudokuGameGenerator();
    _view = new SudokuView();

    addControlStuff();
    print(window.navigator.userAgent);
  }

  addControlStuff() {
    print("Add Control Stuff");

    _clockTrigger = new Timer.periodic(clockTriggerSpeed, (_) => clock());

    _newGameButton.addEventListener('click', newGame);
    _helpButton.addEventListener('click', helpFunc);

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
    _clockCount++;
    _view.updateClock(_clockCount);
  }

  void windowResize(e) {
    _view.resize();
  }

  void newGame(e) {
    _view.setModel(_model.newGame());
    _view.initialUpdate();
    _view.update();
    _view.showHelp(_help);
    _view.setControl();
  }

  void helpFunc(e) {
    _help = !_help;
    _view.showHelp(_help);

  }

  void gameCell(TableCellElement cell) {
    String cellID = cell.id.substring(5);
    int cellRow = int.parse(cellID.substring(0, 1));
    int cellCol = int.parse(cellID.substring(2));
    _model.setGameCell(cellRow, cellCol);

    _view.update();
    _view.showHelp(_help);

    _view.updateWin();
  }

  void controlCell(TableCellElement cell) {

    _model.setControlValue(cell.text);
    _view.updateControl(cell);
    _view.showHelp(_help);
  }
}