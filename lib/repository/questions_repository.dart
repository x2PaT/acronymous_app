import 'dart:math';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';

class QuestionsRepository {
  QuestionsRepository({
    required this.acronymsRepository,
  });

  final AcronymsRepository acronymsRepository;

  Future<List<QuestionModel>> getQuizQuestions(int quizLenght) async {
    List acronymsList = await acronymsRepository.getAcronymsModels();

    List<QuestionModel> questionList = [];
    //
    for (var i = 0; i < quizLenght; i++) {
      List subAcronymsList = List.from(acronymsList);

      List<AnswerModel> answersList = [];

      int qIndex = getRandomIndex(acronymsList.length);

      answersList.add(AnswerModel(acronymsList[qIndex].meaning, true));
      subAcronymsList.removeAt(qIndex);

      for (var i = 0; i < 3; i++) {
        int aIndex = getRandomIndex(subAcronymsList.length);
        answersList.add(AnswerModel(subAcronymsList[aIndex].meaning, false));
        subAcronymsList.removeAt(aIndex);
      }

      answersList.shuffle();

      questionList.add(
        QuestionModel(
          acronymsList[qIndex].acronym,
          answersList,
        ),
      );

      acronymsList.removeAt(qIndex);
    }
    questionList.shuffle();

    return questionList;
  }

  int getRandomIndex(int acronymsModelListLenght) {
    int acronymRandomIndex = Random().nextInt(acronymsModelListLenght - 1);
    return acronymRandomIndex;
  }
}
