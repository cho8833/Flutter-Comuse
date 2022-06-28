// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'History.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String,
      isEntered: json['isEntered'] as bool,
      email: json['email'] as String,
      epoch: json['epoch'] as int,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'epoch': instance.epoch,
      'name': instance.name,
      'isEntered': instance.isEntered,
      'email': instance.email,
      'month': instance.month,
      'year': instance.year,
      'day': instance.day,
    };
