// Copyright (c) 2017, Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;



class SudokuController {
  
  final _overlay = document.getElementById("overlay");
  final _standardSudokuButton = document.getElementById("standardSudokuButton");
  final _xSudokuButton = document.getElementById("xSudokuButton");
  final _hyperSudokuButton = document.getElementById("hyperSudokuButton");
  final _middlepointSudokuButton = document.getElementById("middlepointSudokuButton");
  final _colorSudokuButton = document.getElementById("colorSudokuButton");
  final _nonominoSudokuButton = document.getElementById("nonominoSudokuButton");
  final _helpButton = document.getElementById("helpButton");
  bool _help = false;

  final clockTriggerSpeed = const Duration(milliseconds: 1000);
  Timer clockTrigger;
  Stopwatch stopwatch;

  SudokuGameGenerator _model;
  abstractSudoku _sudoku;

  SudokuView _view;

  SudokuController () {
    _model = new SudokuGameGenerator();
    _view = new SudokuView();

    addControlStuff();
    print(window.navigator.userAgent);
    
  }

  addControlStuff() {
    print("Add Control Stuff");

    clockTrigger = new Timer.periodic(clockTriggerSpeed, (_) => clock());
    stopwatch = new Stopwatch();
    stopwatch.start();

    _standardSudokuButton.addEventListener('click', newStandardSudoku);
    _xSudokuButton.addEventListener('click', newXSudoku);
    _hyperSudokuButton.addEventListener('click', newHyperSudoku);
    _middlepointSudokuButton.addEventListener('click', newMiddlepointSudoku);
    _colorSudokuButton.addEventListener('click', newColorSudoku);
    _nonominoSudokuButton.addEventListener('click', newNonominoSudoku);

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
    _view.updateClock(stopwatch.elapsed);
  }

  void windowResize(e) {
    _view.resize();
  }

  void newStandardSudoku(e) {
    newGame(GameTypes.STANDARD_SUDOKU);
  }

  void newXSudoku(e) {
    newGame(GameTypes.X_SUDOKU);
  }

  void newHyperSudoku(e) {
    newGame(GameTypes.HYPER_SUDOKU);
  }

  void newMiddlepointSudoku(e) {
    newGame(GameTypes.MIDDELPOINT_SUDOKU);
  }

  void newColorSudoku(e) {
    newGame(GameTypes.COLOR_SUDOKU);
  }

  void newNonominoSudoku(e) {
    newGame(GameTypes.NONOMINO_SUDOKU);
  }

  void newGame(GameTypes gameType) {
    print(gameType);
    _sudoku = _model.newGame(gameType);
    print(_sudoku);
    /*
    print(test.getGameFieldSolved());
    print(test.getGameField());
    print(test.getUserInput());
    */

    _view.setModel(_sudoku);
    _view.initialUpdate();
    _view.update();
    _view.showHelp(_help);
    _view.setControl();
    stopwatch.reset();
    _view.updateClock(stopwatch.elapsed);
  }

  void helpFunc(e) {
    _help = !_help;
    _view.showHelp(_help);

  }

  void gameCell(TableCellElement cell) {
    String cellID = cell.id.substring(5);
    int cellRow = int.parse(cellID.substring(0, 1));
    int cellCol = int.parse(cellID.substring(2));
    _sudoku.setGameCell(cellRow, cellCol);

    _view.update();
    _view.showHelp(_help);

    _view.updateWin();
  }

  void controlCell(TableCellElement cell) {

    _sudoku.setControlValue(cell.text);
    _view.updateControl(cell);
    _view.showHelp(_help);
  }
}