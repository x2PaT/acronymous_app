import 'package:json_annotation/json_annotation.dart';

part 'letter_model.g.dart';

@JsonSerializable()
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

  factory LetterModel.fromJson(Map<String, dynamic> json) =>
      _$LetterModelFromJson(json);

  Map<String, dynamic> toJson() => _$LetterModelToJson(this);
}
