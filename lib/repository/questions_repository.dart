import 'dart:math';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/name_model.dart';
import 'package:acronymous_app/models/question_model.dart';

class QuestionsRepository {
  QuestionsRepository();

  Future<List<QuestionModel>> getQuizQuestions(
    int quizLenght,
    List modelsList,
    String quizType,
  ) async {
    List<QuestionModel> questionList = [];

    switch (quizType) {
      case 'acronyms':
        for (var i = 0; i < quizLenght; i++) {
          modelsList as List<AcronymModel>;
          List<AcronymModel> subModelsList = List.from(modelsList);

          List<AnswerModel> answersList = [];

          int qIndex = getRandomIndex(modelsList.length);

          answersList.add(AnswerModel(modelsList[qIndex].meaning, true));
          subModelsList.removeAt(qIndex);

          for (var i = 0; i < 3; i++) {
            int aIndex = getRandomIndex(subModelsList.length);
            answersList.add(AnswerModel(subModelsList[aIndex].meaning, false));
            subModelsList.removeAt(aIndex);
          }

          answersList.shuffle();

          questionList
              .add(QuestionModel(modelsList[qIndex].acronym, answersList));

          modelsList.removeAt(qIndex);
        }
        break;
      case 'names':
        for (var i = 0; i < quizLenght; i++) {
          modelsList as List<NameModel>;
          List<NameModel> subModelsList = List.from(modelsList);

          List<AnswerModel> answersList = [];

          int qIndex = getRandomIndex(modelsList.length);

          answersList.add(AnswerModel(modelsList[qIndex].name, true));
          subModelsList.removeAt(qIndex);

          for (var i = 0; i < 3; i++) {
            int aIndex = getRandomIndex(subModelsList.length);
            answersList.add(AnswerModel(subModelsList[aIndex].name, false));
            subModelsList.removeAt(aIndex);
          }

          answersList.shuffle();

          questionList.add(QuestionModel(modelsList[qIndex].name, answersList));

          modelsList.removeAt(qIndex);
        }
    }

    questionList.shuffle();

    return questionList;
  }

  int getRandomIndex(int modelsListLenght) {
    int modelRandomIndex = Random().nextInt(modelsListLenght - 1);
    return modelRandomIndex;
  }
}
