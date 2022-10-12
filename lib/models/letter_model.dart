class LetterModel {
  LetterModel({
    required this.letter,
    required this.name,
    required this.pronunciation,
    required this.useFrequency,
  });
  final String letter;
  final String name;
  final String pronunciation;
  final String useFrequency;

  LetterModel.fromJson(
    Map<String, dynamic> json,
  )   : letter = json['letter'],
        name = json['name'],
        pronunciation = json['pronunciation'],
        useFrequency = json['useFrequency'];
}
