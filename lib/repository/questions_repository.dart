import 'dart:math';
import 'package:acronymous_app/models/question_model.dart';

class QuestionsRepository {
  QuestionsRepository();

  Future<List<QuestionModel>> getQuizQuestions(
    int quizLenght,
    List modelsList,
    String modelName,
  ) async {
    // List<AcronymModel> acronymsList =
    //     await acronymsRepository.getAcronymsModels();

    List<QuestionModel> questionList = [];

    for (var i = 0; i < quizLenght; i++) {
      List subModelsList = List.from(modelsList);

      List<AnswerModel> answersList = [];

      int qIndex = getRandomIndex(modelsList.length);

      answersList.add(modelName == 'acronyms'
          ? AnswerModel(modelsList[qIndex].meaning, true)
          : AnswerModel(modelsList[qIndex].name, true));
      subModelsList.removeAt(qIndex);

      for (var i = 0; i < 3; i++) {
        int aIndex = getRandomIndex(subModelsList.length);
        answersList.add(modelName == 'acronyms'
            ? AnswerModel(subModelsList[aIndex].meaning, false)
            : AnswerModel(subModelsList[aIndex].name, false));
        subModelsList.removeAt(aIndex);
      }

      answersList.shuffle();

      questionList.add(
        modelName == 'acronyms'
            ? QuestionModel(modelsList[qIndex].acronym, answersList)
            : QuestionModel(modelsList[qIndex].name, answersList),
      );

      modelsList.removeAt(qIndex);
    }
    questionList.shuffle();

    return questionList;
  }

  int getRandomIndex(int modelsListLenght) {
    int modelRandomIndex = Random().nextInt(modelsListLenght - 1);
    return modelRandomIndex;
  }
}
