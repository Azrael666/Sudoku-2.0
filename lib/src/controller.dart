// Copyright (c) 2017, Kevin Joe Reif & Dirk Teschner. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of sudokulib;

/**
 * Constant to define the update speed of the clock.
 * A speed of 1000ms means the clock is updated once per second.
 */
const _clockTriggerSpeed = const Duration(milliseconds: 1000);

/**
 * A [SudokuController] object registers several handlers
 * to grab interactions of a user with a [Sudoku] and translates
 * them into valid [Sudoku] actions.
 *
 * Changing [Sudoku] states or View changes are delegated
 * to the [SudokuView] object.
 */

class SudokuController {

  /**
   * Element with id 'overlay' of the DOM tree.
   * Used to display overlay forms.
   * (e.g. Win overlay or game type selection)
   */
  final _overlay = document.getElementById("overlay");

  /**
   * Element with id 'newGameButton' of the DOM tree.
   * Used for starting a new game.
   */
  final _newGameButton = document.getElementById("newGameButton");

  /**
   * Element with id 'helpButton' of the DOM tree
   * Used for triggering the help functionality.
   */
  final _helpButton = document.getElementById("helpButton");

  /**
   * Represents state of the help functionality
   */
  bool _help = false;


  /**
   * Periodic trigger controlling update of the playing time.
   */
  Timer _clockTrigger;

  /**
   * Stopwatch that measures the playing time of the current sudoku game.
   */
  Stopwatch _stopwatch;

  /**
   * Reference to the [SudokuGenerator].
   */
  SudokuGenerator _model;

  /**
   * Reference to the current [Sudoku].
   */
  Sudoku _sudoku;

  /**
   * Reference to the [SudokuView].
   */
  SudokuView _view;

  /**
   * Constructor to create a [SudokuController] object.
   */
  SudokuController () {
    _model = new SudokuGenerator();
    _view = new SudokuView();

    addControlElements();
  }

  /**
   * Initializes all necessary event handlers for a player
   * to start a new [Sudoku].
   */
  addControlElements() {

    // Initialize Timer & Stopwatch for playing time
    _clockTrigger = new Timer.periodic(_clockTriggerSpeed, (_) => clock());
    _stopwatch = new Stopwatch();

    // Buttons
    _newGameButton.addEventListener('click', newGameButton);
    _helpButton.addEventListener('click', helpFunc);

    // Resize event
    window.addEventListener('resize', windowResize);

    // [Sudoku] gameField
    List<TableCellElement> gameCells = document.querySelectorAll(".GameCell");
    for (TableCellElement cell in gameCells) {
      cell.addEventListener('click',
              (event) => gameCell(cell));
    }

    // Control fields
    List<TableCellElement> controlCells = document.querySelectorAll(
        ".ControlCell");
    for (TableCellElement cell in controlCells) {
      cell.addEventListener('click',
              (event) => controlCell(cell));
    }

    // Hint
    TableCellElement cell = document.querySelector("#Control_Hint");
    cell.addEventListener('click',
            (event) => showCell(cell));
  }

  /**
   * Updates the clock in the top right corner.
   */
  void clock() {
    _view.updateClock(_stopwatch.elapsed);
  }

  /**
   * Updates the resolution of DOM tree elements and
   * shows warning overlay to turn small devices in landscape orientation.
   */

  void windowResize(e) {
    _view.resize();
  }

  /**
   * starts new standard-sudoku game.
   */
  void newStandardSudoku(e) {
    newGame(GameTypes.STANDARD_SUDOKU);
  }

  /**
   * starts new x-sudoku game.
   */
  void newXSudoku(e) {
    newGame(GameTypes.X_SUDOKU);
  }

  /**
   * starts new hyper-sudoku game.
   */
  void newHyperSudoku(e) {
    newGame(GameTypes.HYPER_SUDOKU);
  }

  /**
   * starts new middlepoint-sudoku game.
   */
  void newMiddlepointSudoku(e) {
    newGame(GameTypes.MIDDELPOINT_SUDOKU);
  }

  /**
   * starts new color-sudoku game.
   */
  void newColorSudoku(e) {
    newGame(GameTypes.COLOR_SUDOKU);
  }

  /**
   * starts new nonomino-sudoku game.
   */
  void newNonominoSudoku(e) {
    newGame(GameTypes.NONOMINO_SUDOKU);
  }

  /**
   * Handles click on 'New Game' button.
   *
   * Opens overlay with images of game types
   * that the user can choose to play.
   */
  void newGameButton(e) {

    // Display overlay with images
    _view.updateNewGame();

    // Get image elements
    HtmlElement standardButton = document.getElementById("newStandardSudoku");
    HtmlElement xButton = document.getElementById("newXSudoku");
    HtmlElement hyperButton = document.getElementById("newHyperSudoku");
    HtmlElement middlepointButton = document.getElementById("newMiddlepointSudoku");
    HtmlElement colorButton = document.getElementById("newColorSudoku");
    HtmlElement nonominoButton = document.getElementById("newNonominoSudoku");

    // Add event listeners to images
    standardButton.addEventListener('click', newStandardSudoku);
    xButton.addEventListener('click', newXSudoku);
    hyperButton.addEventListener('click', newHyperSudoku);
    middlepointButton.addEventListener('click', newMiddlepointSudoku);
    colorButton.addEventListener('click', newColorSudoku);
    nonominoButton.addEventListener('click', newNonominoSudoku);

    // Add event listener to close overlay
    _overlay.addEventListener('click',
            (event) => _overlay.innerHtml = "");

  }

  /**
   * Generates a new game according to [gameType].
   *
   * Also updates view & starts stopwatch.
   */
  void newGame(GameTypes gameType) {
    // Generate new [Sudoku]
    _sudoku = _model.newGame(gameType);

    // Update view
    _view.setModel(_sudoku);
    _view.initialUpdate();
    _view.update();
    _view.showHelp(_help);
    _view.setControl();

    // Reset & start stopwatch
    _stopwatch.reset();
    _stopwatch.start();
    _view.updateClock(_stopwatch.elapsed);
  }

  /**
   * Handles help functionality which highlights specific numbers in the sudoku.
   */
  void helpFunc(e) {
    if(_sudoku != null) {
      _help = !_help;
      _view.showHelp(_help);
    }
  }

  /**
   * Handles click on game field cells
   */
  void gameCell(TableCellElement cell) {
    if(_sudoku != null) {
      // Get cell number
      String cellID = cell.id.substring(5);
      int cellRow = int.parse(cellID.substring(0, 1));
      int cellCol = int.parse(cellID.substring(2));

      // Set game cell
      _sudoku.setGameCell(cellRow, cellCol);

      // Update view
      _view.update();
      _view.showHelp(_help);
      updateWin();

    }
  }

  /**
   * Checks if the [Sudoku] is solved and updates view if it is
   */
  void updateWin() {

    if(_sudoku.isSolved()) {
      // Stop stopwatch
      _stopwatch.stop();

      // Show win overlay
      _view.updateWin(_stopwatch.elapsed);

      // Add event listener to close overlay
      _overlay.addEventListener('click',
              (event) => _overlay.innerHtml = "");
    }

  }

  /**
   * Handles click on hint control
   */
  void showCell(TableCellElement cell){
    if(_sudoku != null) {
      _sudoku.setControlValue("hint");
      _view.updateControl(cell);
      _view.showHelp(_help);
    }
  }

  /**
   * Handles click on control cells
   */
  void controlCell(TableCellElement cell) {
    if(_sudoku != null) {
      if(!cell.text.contains("hint")) {
        _sudoku.setControlValue(cell.text);
        _view.updateControl(cell);
        _view.showHelp(_help);
      }
    }
  }
}