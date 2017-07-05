// Copyright (c) 2017, Kevin Joe Reif & Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

class SudokuController {

  final _overlay = document.getElementById("overlay");
  final _newGameButton = document.getElementById("newGameButton");
  final _helpButton = document.getElementById("helpButton");
  bool _hint = false;

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
  }

  addControlStuff() {

    clockTrigger = new Timer.periodic(clockTriggerSpeed, (_) => clock());
    stopwatch = new Stopwatch();

    _newGameButton.addEventListener('click', newGameButton);
    _helpButton.addEventListener('click', hintFunc);

    window.addEventListener('resize', windowResize);

    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");
    for (TableCellElement cell in gameCells) {
      cell.addEventListener('click',
              (event) => gameCell(cell));
    }

    List<TableCellElement> controlCells = document.querySelectorAll(
        ".ControlCell");
    for (TableCellElement cell in controlCells) {
      cell.addEventListener('click',
              (event) => controlCell(cell));
    }

    TableCellElement cell = document.querySelector("#Control_Show");
    cell.addEventListener('click',
            (event) => showCell(cell));
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

  void newGameButton(e) {
    _view.updateNewGame();

    HtmlElement standardButton = document.getElementById("newStandardSudoku");
    HtmlElement xButton = document.getElementById("newXSudoku");
    HtmlElement hyperButton = document.getElementById("newHyperSudoku");
    HtmlElement middlepointButton = document.getElementById("newMiddlepointSudoku");
    HtmlElement colorButton = document.getElementById("newColorSudoku");
    HtmlElement nonominoButton = document.getElementById("newNonominoSudoku");

    standardButton.addEventListener('click', newStandardSudoku);
    xButton.addEventListener('click', newXSudoku);
    hyperButton.addEventListener('click', newHyperSudoku);
    middlepointButton.addEventListener('click', newMiddlepointSudoku);
    colorButton.addEventListener('click', newColorSudoku);
    nonominoButton.addEventListener('click', newNonominoSudoku);


    _overlay.addEventListener('click',
            (event) => _overlay.innerHtml = "");

  }

  void newGame(GameTypes gameType) {
    _sudoku = _model.newGame(gameType);

    _view.setModel(_sudoku);
    _view.initialUpdate();
    _view.update();
    _view.showHint(_hint);
    _view.setControl();
    stopwatch.reset();
    stopwatch.start();
    _view.updateClock(stopwatch.elapsed);
  }

  void hintFunc(e) {
    if(_sudoku != null) {
      _hint = !_hint;
      _view.showHint(_hint);
    }
  }

  void gameCell(TableCellElement cell) {
    if(_sudoku != null) {
      String cellID = cell.id.substring(5);
      int cellRow = int.parse(cellID.substring(0, 1));
      int cellCol = int.parse(cellID.substring(2));
      _sudoku.setGameCell(cellRow, cellCol);

      _view.update();
      _view.showHint(_hint);

      updateWin();

    }
  }

  void updateWin() {

    if(_sudoku.isSolved()) {
      stopwatch.stop();

      _view.updateWin(stopwatch.elapsed);

      _overlay.addEventListener('click',
              (event) => _overlay.innerHtml = "");
    }

  }

  void showCell(TableCellElement cell){
    if(_sudoku != null) {
      _sudoku.setControlValue("show");
      _view.updateControl(cell);
      _view.showHint(_hint);
    }
  }

  void controlCell(TableCellElement cell) {
    if(_sudoku != null) {
      if(!cell.text.contains("show")) {
        _sudoku.setControlValue(cell.text);
        _view.updateControl(cell);
        _view.showHint(_hint);
      }
    }
  }
}