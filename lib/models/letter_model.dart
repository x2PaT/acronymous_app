class LetterModel {
  LetterModel({
    required this.id,
    required this.letter,
    required this.name,
    required this.pronunciation,
    required this.useFrequency,
  });
  final int id;
  final String letter;
  final String name;
  final String pronunciation;
  final String useFrequency;

  LetterModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        letter = json['letter'],
        name = json['name'],
        pronunciation = json['pronunciation'],
        useFrequency = json['useFrequency'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'letter': letter,
      'name': name,
      'pronunciation': pronunciation,
      'useFrequency': useFrequency,
    };
  }
}
