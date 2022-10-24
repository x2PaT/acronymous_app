class AcronymModel {
  AcronymModel({
    required this.id,
    required this.acronym,
    required this.meaning,
  });
  final int id;
  final String acronym;
  final String meaning;

  String get acronymLetters {
    // ABC >>> A, B, C
    return acronym.split('').join(', ');
  }

  AcronymModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        acronym = json['acronym'],
        meaning = json['meaning'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'acronym': acronym,
      'meaning': meaning,
    };
  }
}
