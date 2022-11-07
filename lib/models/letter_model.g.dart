// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LetterModel _$LetterModelFromJson(Map<String, dynamic> json) => LetterModel(
      id: json['id'] as int,
      letter: json['letter'] as String,
      name: json['name'] as String,
      pronunciation: json['pronunciation'] as String,
      useFrequency: json['useFrequency'] as String,
    );

Map<String, dynamic> _$LetterModelToJson(LetterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'letter': instance.letter,
      'name': instance.name,
      'pronunciation': instance.pronunciation,
      'useFrequency': instance.useFrequency,
    };
