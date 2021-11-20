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

import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/cell.dart';
import 'package:google_fonts/google_fonts.dart';

class CellWidget extends StatefulWidget {
  const CellWidget({
    Key key,
    @required this.size,
    @required this.cell,
  }) : super(key: key);

  final int size;
  final CellModel cell;

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 1, bottom: 1),
      height: MediaQuery.of(context).size.width / widget.size + 1,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        color: widget.cell.isRevealed ? (widget.cell.isMine ? Colors.red[100] : Colors.grey[200 + (widget.cell.value * 50)]) : Colors.white,
      ),
      child: (widget.cell.isMine && widget.cell.isRevealed)
          ? Center(
              child: Icon(
                Icons.clear,
                color: Colors.red,
              ),
            )
          : widget.cell.isFlagged
              ? Center(
                  child: Icon(
                    Icons.flag,
                    color: Colors.red[400],
                  ),
                )
              : widget.cell.isRevealed
                  ? Center(
                      child: Text(
                        widget.cell.value.toString(),
                        style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  : Container(),
    );
  }
}
