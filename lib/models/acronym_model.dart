import 'package:json_annotation/json_annotation.dart';

part 'acronym_model.g.dart';

@JsonSerializable()
class AcronymModel {
  AcronymModel({
    required this.id,
    required this.acronym,
    required this.meaning,
  });
  @JsonKey(name: 'id')
  final int id;
  final String acronym;
  final String meaning;

  String get acronymLetters {
    // ABC >>> A, B, C
    return acronym.split('').join(', ');
  }

  factory AcronymModel.fromJson(Map<String, dynamic> json) =>
      _$AcronymModelFromJson(json);

  Map<String, dynamic> toJson() => _$AcronymModelToJson(this);

  // AcronymModel.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       acronym = json['acronym'],
  //       meaning = json['meaning'];
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'acronym': acronym,
  //     'meaning': meaning,
  //   };
  // }
}
