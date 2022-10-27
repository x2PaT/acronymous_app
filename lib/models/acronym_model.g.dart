// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acronym_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcronymModel _$AcronymModelFromJson(Map<String, dynamic> json) => AcronymModel(
      id: json['id'] as int,
      acronym: json['acronym'] as String,
      meaning: json['meaning'] as String,
    );

Map<String, dynamic> _$AcronymModelToJson(AcronymModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'acronym': instance.acronym,
      'meaning': instance.meaning,
    };
