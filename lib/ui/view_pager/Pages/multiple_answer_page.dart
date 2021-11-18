import 'package:flutter/cupertino.dart';
import 'package:some_lessons_from_youtube/domain/question.dart';
import 'package:some_lessons_from_youtube/ui/view_pager/Items/multiple_answer_item.dart';

import 'abstract_answer_page.dart';

class MultipleAnswerPage extends StatefulWidget with AbstractAnswerPage  {

  MultipleAnswerPage({Key? key, required this.currentQuestion}) : super(key: key) {
    currentQuestion.questionList.forEach((element) {
      items.add(
          CustomCheckBox(
            size: 26,
            text: element,
          )
      );
    });
  }

  Question currentQuestion;
  List<CustomCheckBox> items = [];

  @override
  State createState() => _MultipleAnswerPageState();

  @override
  List<String> getAnswers() {

    List<String> result = [];

    items.forEach((element) {
      if (element.isSelected) {
        result.add(element.text);
      }
    });

    return result;
  }

  @override
  int getId() {
    return currentQuestion.id;
  }
}

class _MultipleAnswerPageState extends State<MultipleAnswerPage> {

  void resetRadioButtons(String text) {
    setState(() {
      for (var element in widget.items) {
        element.isSelected = false;
      }

      widget.items.where((element) => element.text == text).first.isSelected = true;
    });

    rebuildAllChildren(context);

  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.currentQuestion.text,
          style: const TextStyle(
              fontFamily: "Montserrat",
              color: Color(0xFF4f4f4f),
              fontWeight: FontWeight.w800,
              fontSize: 22
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              return widget.items[index];
            },
          ),
        )
      ],
    );
  }
}