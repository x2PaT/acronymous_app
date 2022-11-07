import 'package:json_annotation/json_annotation.dart';

part 'name_model.g.dart';

@JsonSerializable()
class NameModel {
  NameModel({
    required this.id,
    required this.name,
  });
  final int id;
  final String name;

  String get nameLetters {
    // ABC >>> A, B, C
    return name.split('').join(', ');
  }

  factory NameModel.fromJson(Map<String, dynamic> json) =>
      _$NameModelFromJson(json);

  Map<String, dynamic> toJson() => _$NameModelToJson(this);
}
