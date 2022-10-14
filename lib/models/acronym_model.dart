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
    final String splitToLetters = '${acronym.split('').map((e) => e)}';

    return splitToLetters;
  }

  AcronymModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        acronym = json['acronym'],
        meaning = json['meaning'];
}
