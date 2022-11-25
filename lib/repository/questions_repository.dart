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

  Future<List<QuizQuestionModel>> getQuizQuestions(
    int quizLenght,
    String quizType,
  ) async {
    switch (quizType) {
      case 'acronyms':
        return await createAcronymsQuizQuestions(quizLenght);

      case 'names':
        return await createNamesQuizQuestions(quizLenght);

      case 'randomLetters':
        return await createRandomLettersQuizQuestions(quizLenght);

      default:
        throw Exception('Bad quiz type');
    }
  }

  Future<List<QuizQuestionModel>> createAcronymsQuizQuestions(
      int quizLenght) async {
    List<QuizQuestionModel> questionList = [];
    final elementsList = await acronymsRepository.getAcronymsModels();

    for (var i = 0; i < quizLenght; i++) {
      List<AcronymModel> subModelsList = List.from(elementsList);

      List<QuizOptionModel> optionsList = [];

      int qIndex = getRandomIndex(elementsList.length);

      optionsList.add(QuizOptionModel(elementsList[qIndex].meaning, true));
      subModelsList.removeAt(qIndex);

      for (var i = 0; i < 3; i++) {
        int aIndex = getRandomIndex(subModelsList.length);
        optionsList.add(QuizOptionModel(subModelsList[aIndex].meaning, false));
        subModelsList.removeAt(aIndex);
      }

      optionsList.shuffle();

      questionList.add(
        QuizQuestionModel(elementsList[qIndex].acronym, optionsList),
      );

      elementsList.removeAt(qIndex);
    }
    questionList.shuffle();

    return questionList;
  }

  Future<List<QuizQuestionModel>> createNamesQuizQuestions(
      int quizLenght) async {
    List<QuizQuestionModel> questionList = [];
    final elementsList = await namesRepository.getNamesModels();

    for (var i = 0; i < quizLenght; i++) {
      List<NameModel> subModelsList = List.from(elementsList);

      List<QuizOptionModel> optionsList = [];

      int qIndex = getRandomIndex(elementsList.length);

      optionsList.add(QuizOptionModel(elementsList[qIndex].name, true));
      subModelsList.removeAt(qIndex);

      for (var i = 0; i < 3; i++) {
        int aIndex = getRandomIndex(subModelsList.length);
        optionsList.add(QuizOptionModel(subModelsList[aIndex].name, false));
        subModelsList.removeAt(aIndex);
      }

      optionsList.shuffle();

      questionList.add(
        QuizQuestionModel(elementsList[qIndex].name, optionsList),
      );

      elementsList.removeAt(qIndex);
    }
    questionList.shuffle();

    return questionList;
  }

  Future<List<QuizQuestionModel>> createRandomLettersQuizQuestions(
      int quizLenght) async {
    const int questionLenght = 6;
    const int optionsAmount = 4;
    // bool modeEightLetters = false;
    List<QuizQuestionModel> questionList = [];

    final lettersListAll = await alphabetRepository.getAlphabetLettersList();
    List lettersList = [];
    // modeEightLetters
    //     // ignore: dead_code
    //     ? {
    //         for (var i = 0; i < 8; i++)
    //           {
    //             lettersList
    //                 .add(lettersListAll[getRandomIndex(lettersListAll.length)])
    //           }
    //       }
    //     :
    lettersList = List.from(lettersListAll);

    for (var i = 0; i < quizLenght; i++) {
      List<QuizOptionModel> optionsList = [];

      // build quiestion string
      String question = '';
      for (var i = 0; i < questionLenght; i++) {
        question += lettersList[getRandomIndex(lettersList.length)];
      }
      optionsList.add(QuizOptionModel(question, true));

      //build option list
      for (var i = 0; i < optionsAmount - 1; i++) {
        //build option
        String option = '';
        for (var j = 0; j < questionLenght; j++) {
          option += lettersList[getRandomIndex(lettersList.length)];
        }
        optionsList.add(QuizOptionModel(option, false));
      }
      optionsList.shuffle();

      questionList.add(QuizQuestionModel(question, optionsList));
    }

    questionList.shuffle();

    return questionList;
  }

  int getRandomIndex(int modelsListLenght) {
    int modelRandomIndex = Random().nextInt(modelsListLenght - 1);
    return modelRandomIndex;
  }
}
