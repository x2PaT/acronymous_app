import 'dart:math';
import 'package:acronymous_app/models/acronym_model.dart';
import 'package:acronymous_app/models/name_model.dart';
import 'package:acronymous_app/models/question_model.dart';
import 'package:acronymous_app/repository/acronyms_repository.dart';
import 'package:acronymous_app/repository/alphabet_repository.dart';
import 'package:acronymous_app/repository/names_repository.dart';

class QuestionsRepository {
  QuestionsRepository({
    required this.acronymsRepository,
    required this.namesRepository,
    required this.alphabetRepository,
  });

  final AcronymsRepository acronymsRepository;
  final NamesRepository namesRepository;
  final AlphabetRepository alphabetRepository;

  Future<List<QuestionModel>> getQuizQuestions(
    int quizLenght,
    String quizType,
  ) async {
    switch (quizType) {
      case 'acronyms':
        List<QuestionModel> questionList = [];
        final elementsList = await acronymsRepository.getAcronymsModels();

        for (var i = 0; i < quizLenght; i++) {
          List<AcronymModel> subModelsList = List.from(elementsList);

          List<AnswerModel> answersList = [];

          int qIndex = getRandomIndex(elementsList.length);

          answersList.add(AnswerModel(elementsList[qIndex].meaning, true));
          subModelsList.removeAt(qIndex);

          for (var i = 0; i < 3; i++) {
            int aIndex = getRandomIndex(subModelsList.length);
            answersList.add(AnswerModel(subModelsList[aIndex].meaning, false));
            subModelsList.removeAt(aIndex);
          }

          answersList.shuffle();

          questionList
              .add(QuestionModel(elementsList[qIndex].acronym, answersList));

          elementsList.removeAt(qIndex);
        }
        questionList.shuffle();

        return questionList;

      case 'names':
        List<QuestionModel> questionList = [];
        final elementsList = await namesRepository.getNamesModels();

        for (var i = 0; i < quizLenght; i++) {
          List<NameModel> subModelsList = List.from(elementsList);

          List<AnswerModel> answersList = [];

          int qIndex = getRandomIndex(elementsList.length);

          answersList.add(AnswerModel(elementsList[qIndex].name, true));
          subModelsList.removeAt(qIndex);

          for (var i = 0; i < 3; i++) {
            int aIndex = getRandomIndex(subModelsList.length);
            answersList.add(AnswerModel(subModelsList[aIndex].name, false));
            subModelsList.removeAt(aIndex);
          }

          answersList.shuffle();

          questionList
              .add(QuestionModel(elementsList[qIndex].name, answersList));

          elementsList.removeAt(qIndex);
        }
        questionList.shuffle();

        return questionList;

      case 'randomLetters':
        const int questionLenght = 6;
        const int answersAmount = 4;
        bool modeEightLetters = false;
        List<QuestionModel> questionList = [];

        final lettersListAll =
            await alphabetRepository.getAlphabetLettersList();
        List lettersList = [];
        modeEightLetters
            // ignore: dead_code
            ? {
                for (var i = 0; i < 8; i++)
                  {
                    lettersList.add(
                        lettersListAll[getRandomIndex(lettersListAll.length)])
                  }
              }
            : lettersList = List.from(lettersListAll);

        for (var i = 0; i < quizLenght; i++) {
          List<AnswerModel> answersList = [];

          // build quiestion string
          String question = '';
          for (var i = 0; i < questionLenght; i++) {
            question += lettersList[getRandomIndex(lettersList.length)];
          }
          answersList.add(AnswerModel(question, true));

          //build answers list
          for (var i = 0; i < answersAmount - 1; i++) {
            //build answer
            String answer = '';
            for (var j = 0; j < questionLenght; j++) {
              answer += lettersList[getRandomIndex(lettersList.length)];
            }
            answersList.add(AnswerModel(answer, false));
          }
          answersList.shuffle();

          questionList.add(QuestionModel(question, answersList));
        }

        questionList.shuffle();

        return questionList;
      default:
        throw Exception('Bad quiz type');
    }
  }

  int getRandomIndex(int modelsListLenght) {
    int modelRandomIndex = Random().nextInt(modelsListLenght - 1);
    return modelRandomIndex;
  }
}
