/*
Copyright (c) 2021 Razeware LLC

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify,
    merge, publish, distribute, sublicense, create a derivative work,
and/or sell copies of the Software in any work that is designed,
intended, or marketed for pedagogical or instructional purposes
related to programming, coding, application development, or
information technology. Permission for such use, copying,
    modification, merger, publication, distribution, sublicensing,
    creation of derivative works, or sale is expressly withheld.

This project and source code may use libraries or frameworks
that are released under various Open-Source licenses. Use of
those libraries and frameworks are governed by their own
individual licenses.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_minesweeper/cell.dart';
import 'package:flutter_minesweeper/cell_widget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('jp', ''),
        const Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final rules = [
    "Rules",
    "\n\nA player taps on a cell to uncover it. If a player uncovers a mined cell, the game ends, as there is only 1 life per game.",
    "\n\nOtherwise, the uncovered cells displays either a number, indicating the quantity of mines diagonally and/or adjacent to it, or a blank tile (or \"0\"), and all adjacent non-mined cells will automatically be uncovered.",
    "\n\nTap-and-hold on a cell will flag it, causing a flag to appear on it. Flagged cells are still considered covered.",
    "\n\nTo win the game, players must uncover all non-mine cells, at which point,",
  ];
  var size = 5;
  var cells = [];
  var totalCellsRevealed = 0;
  var totalMines = 0;

  void generateGrid() {
    cells = [];
    totalCellsRevealed = 0;
    totalMines = 0;

    for (int i = 0; i < size; i++) {
      var row = [];
      for (int j = 0; j < size; j++) {
        final cell = CellModel(i, j);
        row.add(cell);
      }
      cells.add(row);
    }

    // Marking mines
    for (int i = 0; i < size; ++i) {
      cells[Random().nextInt(size)][Random().nextInt(size)].isMine = true;
    }

    // Counting mines
    for (int i = 0; i < cells.length; ++i) {
      for (int j = 0; j < cells[i].length; ++j) {
        if (cells[i][j].isMine) totalMines++;
      }
    }

    // Updating values of cells in Moore's neighbourhood of mines
    for (int i = 0; i < cells.length; ++i) {
      for (int j = 0; j < cells[i].length; ++j) {
        if (cells[i][j].isMine) {
          createInitialNumbersAroundMine(cells[i][j]);
        }
      }
    }
  }

  Widget buildButton(CellModel cell) {
    return GestureDetector(
      onLongPress: () {
        markFlagged(cell);
      },
      onTap: () {
        onTap(cell);
      },
      child: CellWidget(
        size: size,
        cell: cell,
      ),
    );
  }

  Row buildButtonRow(int column) {
    List<Widget> list = [];

    for (int i = 0; i < size; i++) {
      list.add(
        Expanded(
          child: buildButton(cells[i][column]),
        ),
      );
    }

    return Row(
      children: list,
    );
  }

  Column buildButtonColumn() {
    List<Widget> rows = [];

    for (int i = 0; i < size; i++) {
      rows.add(
        buildButtonRow(i),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: rows,
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.white,
          value: totalCellsRevealed / (size * size - totalMines),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
        Expanded(
          child: SingleChildScrollView(
            primary: true,
            child: buildRules(),
          ),
        )
      ],
    );
  }

  Column buildRules() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: rules
                        .map(
                          (e) => TextSpan(
                            text: e,
                            style: GoogleFonts.robotoMono(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void createInitialNumbersAroundMine(CellModel cell) {
    // print("Checking mine at " + cell.x.toString() + ", " + cell.y.toString());
    int xStart = (cell.x - 1) < 0 ? 0 : (cell.x - 1);
    int xEnd = (cell.x + 1) > (size - 1) ? (size - 1) : (cell.x + 1);

    int yStart = (cell.y - 1) < 0 ? 0 : (cell.y - 1);
    int yEnd = (cell.y + 1) > (size - 1) ? (size - 1) : (cell.y + 1);

    for (int i = xStart; i <= xEnd; ++i) {
      for (int j = yStart; j <= yEnd; ++j) {
        if (!cells[i][j].isMine) {
          cells[i][j].value++;
        }
      }
    }
  }

  void markFlagged(CellModel cell) {
    cell.isFlagged = !cell.isFlagged;
    setState(() {});
  }

  void onTap(CellModel cell) async {
    // If the first tapped cell is a mine, regenerate the grid
    if (cell.isMine && totalCellsRevealed == 0) {
      while (cells[cell.x][cell.y].isMine == true) {
        restart();
      }

      cell = cells[cell.x][cell.y];
    }

    if (cell.isMine) {
      unrevealRecursively(cell);
      setState(() {});
      final response = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Game Over"),
          content: Text("You stepped on a mine. Be careful next time."),
          actions: [
            MaterialButton(
              color: Colors.deepPurple,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Restart"),
            ),
          ],
        ),
      );

      if (response) {
        restart();
      }
      return;
    } else {
      unrevealRecursively(cell);
      setState(() {});
      if (checkIfPlayerWon()) {
        final response = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Congratulations"),
            content: Text(
                "You discovered all the tiles without stepping on any mines. Well done."),
            actions: [
              MaterialButton(
                color: Colors.deepPurple,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Next Level"),
              ),
            ],
          ),
        );

        if (response) {
          size++;
          restart();
        }
      } else {
        setState(() {});
      }
    }
  }

  void restart() {
    setState(() {
      generateGrid();
    });
  }

  bool checkIfPlayerWon() {
    if (totalCellsRevealed + totalMines == size * size) {
      return true;
    } else {
      return false;
    }
  }

  void unrevealRecursively(CellModel cell) {
    if (cell.x > size ||
        cell.y > size ||
        cell.x < 0 ||
        cell.y < 0 ||
        cell.isRevealed) {
      return;
    }

    cell.isRevealed = true;
    totalCellsRevealed++;

    if (cell.value == 0) {
      int xStart = (cell.x - 1) < 0 ? 0 : (cell.x - 1);
      int xEnd = (cell.x + 1) > (size - 1) ? (size - 1) : (cell.x + 1);

      int yStart = (cell.y - 1) < 0 ? 0 : (cell.y - 1);
      int yEnd = (cell.y + 1) > (size - 1) ? (size - 1) : (cell.y + 1);

      for (int i = xStart; i <= xEnd; ++i) {
        for (int j = yStart; j <= yEnd; ++j) {
          if (!cells[i][j].isMine &&
              !cells[i][j].isRevealed &&
              cells[i][j].value == 0) {
            unrevealRecursively(cells[i][j]);
          }
        }
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    generateGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Minesweeper"),
        actions: [
          IconButton(
            icon: Icon(Icons.fiber_new),
            onPressed: () => restart(),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(1.0),
        child: buildButtonColumn(),
      ),
    );
  }
}
