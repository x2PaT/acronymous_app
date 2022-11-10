import 'package:json_annotation/json_annotation.dart';

part 'word_sandbox.g.dart';

@JsonSerializable()
class WordSandboxModel {
  WordSandboxModel({
    required this.id,
    required this.word,
  });
  final int id;
  final String word;

  factory WordSandboxModel.fromJson(Map<String, dynamic> json) =>
      _$WordSandboxModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordSandboxModelToJson(this);
}
