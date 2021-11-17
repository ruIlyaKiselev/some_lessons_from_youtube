import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSelector extends StatefulWidget {

  CustomSelector({
    Key? key,
    required this.size,
    required this.min,
    required this.max,
    required this.text,
    required this.secondText
  }) : super(key: key) {currentNumber = min;}

  int currentNumber = 0;
  bool isSelected = false;
  int min;
  int max;
  String text;
  String secondText;
  double size;

  void incrementCurrentNumber() {
    if (currentNumber + 1 <= max) {
      currentNumber++;
    }
  }

  void decrementCurrentNumber() {
    if (currentNumber - 1 >= min) {
      currentNumber--;
    }
  }

  @override
  State createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: const Color(0xFF4f4f4f),
                      fontWeight: FontWeight.w800,
                      fontSize: widget.size * 2 / 3
                  ),
                  textAlign: TextAlign.start,
                )
            ),
            Expanded(
                child: Text(
                  widget.secondText,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: const Color(0xFF4f4f4f),
                      fontWeight: FontWeight.w800,
                      fontSize: widget.size / 2
                  ),
                  textAlign: TextAlign.start,
                )
            ),
          ],
        ),

        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF4f4f4f),
                width: widget.size / 10,
              ),
              borderRadius: BorderRadius.circular(widget.size / 4)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  widget.decrementCurrentNumber();
                }),
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: MinusComponentPainter(),
                ),
              ),
              SizedBox(
                width: widget.size * 2.5,
                child: Center(
                  child: Text(
                    widget.currentNumber.toString(),
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        color: const Color(0xFF4f4f4f),
                        fontWeight: FontWeight.w800,
                        fontSize: widget.size * 2 / 3
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  widget.incrementCurrentNumber();
                }),
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: PlusComponentPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlusComponentPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(size.width / 2, size.height * 0.2),
        Offset(size.width / 2, size.height * 0.8),
        Paint()
          ..color = const Color(0xFF4f4f4f)
          ..strokeWidth = min(size.width, size.height) / 10
          ..strokeCap = StrokeCap.round
    );
    canvas.drawLine(
        Offset(size.width * 0.2, size.height / 2),
        Offset(size.width * 0.8, size.height / 2),
        Paint()
          ..color = const Color(0xFF4f4f4f)
          ..strokeWidth = min(size.width, size.height) / 10
          ..strokeCap = StrokeCap.round
    );
    canvas.drawLine(
        const Offset(0, 0),
        Offset(0, size.height),
        Paint()
          ..color = const Color(0xFF4f4f4f)
          ..strokeWidth = min(size.width, size.height) / 10
          ..strokeCap = StrokeCap.round
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MinusComponentPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(size.width * 0.2, size.height / 2),
        Offset(size.width * 0.8, size.height / 2),
        Paint()
          ..color = const Color(0xFF4f4f4f)
          ..strokeWidth = min(size.width, size.height) / 10
          ..strokeCap = StrokeCap.round
    );
    canvas.drawLine(
        Offset(size.width * 0.2, size.height / 2),
        Offset(size.width * 0.8, size.height / 2),
        Paint()
          ..color = const Color(0xFF4f4f4f)
          ..strokeWidth = min(size.width, size.height) / 10
          ..strokeCap = StrokeCap.round
    );
    canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, size.height),
        Paint()
          ..color = const Color(0xFF4f4f4f)
          ..strokeWidth = min(size.width, size.height) / 10
          ..strokeCap = StrokeCap.round
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}