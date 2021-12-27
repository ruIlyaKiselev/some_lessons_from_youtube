
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:some_lessons_from_youtube/domain/answer.dart';
import 'package:some_lessons_from_youtube/domain/question.dart';
import 'package:some_lessons_from_youtube/repository/carbolator_repository.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {

  final CarbolatorRepository _repository;
  List<Question> _questions = [];
  int currentQuestion = -1;
  Set<Answer> answers = {};
  String email = "";

  final Logger _logger = Logger();

  QuestionBloc({
    required CarbolatorRepository carbolatorRepository
  })
      :
        _repository = carbolatorRepository,
        super(LoadingState()) {
    on<QuestionsFetchedEvent>(_onQuestionsFetched);
    on<NewAnswerEvent>(_onNewAnswer);
    on<SendAnswersEvent>(_onSendAnswers);
    on<SendEmailEvent>(_onSendEmail);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PrevQuestionEvent>(_onPrevQuestion);
  }

  FutureOr<void> _onQuestionsFetched(QuestionsFetchedEvent event, Emitter<QuestionState> state) async {
    emit(LoadingState());
    var questionsFromRepository = await _repository.getQuestions();
    if (questionsFromRepository != null && questionsFromRepository.isNotEmpty) {
      _questions = questionsFromRepository;
      emit(LoadedState());
    } else {
      emit(ErrorState());
    }
  }

  FutureOr<void> _onNewAnswer(NewAnswerEvent event, Emitter<QuestionState> state) async {
    answers.removeWhere((element) => element.id == event.answer.id);
    answers.add(event.answer);
    _logger.d("${event.answer.id} ${event.answer.selectedAnswers}");
    var question = _questions[currentQuestion];
  }

  FutureOr<void> _onSendAnswers(SendAnswersEvent event, Emitter<QuestionState> state) async {
    try {
      var results = await _repository.postAnswers(answers.toList());
      emit(AnswersDeliveredSuccessfullyState(results: results));
    } catch (_) {
      emit(AnswersDeliveredUnsuccessfullyState());
    }
  }

  FutureOr<void> _onSendEmail(SendEmailEvent event, Emitter<QuestionState> state) {
    email = event.email;
  }

  FutureOr<void> _onNextQuestion(NextQuestionEvent event, Emitter<QuestionState> emit) {
    if (currentQuestion < _questions.length - 1) {
      currentQuestion++;
      emit(
          QuestionLoadedState(
              question: _questions[currentQuestion],
              storedAnswers: answers.firstWhere((element) => element.id == _questions[currentQuestion].id,
                  orElse: () => Answer(id: 0, selectedAnswers: [])
              ).selectedAnswers
          )
      );
    } else {
      emit(
          QuestionsFinishedState()
      );
    }
  }

  FutureOr<void> _onPrevQuestion(PrevQuestionEvent event, Emitter<QuestionState> emit) {
    if (currentQuestion > 0) {
      currentQuestion--;
      emit(
          QuestionLoadedState(
              question: _questions[currentQuestion],
              storedAnswers: answers.firstWhere((element) => element.id == _questions[currentQuestion].id,
                  orElse: () => Answer(id: 0, selectedAnswers: [])
              ).selectedAnswers
          )
      );
    }
  }
}