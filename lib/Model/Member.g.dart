// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      name: json['name'] as String,
      position:
          (json['position'] as List<dynamic>).map((e) => e as String).toList(),
      isEntered: json['isEntered'] as bool,
      permission: json['permission'] as int,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'isEntered': instance.isEntered,
      'permission': instance.permission,
      'uid': instance.uid,
    };
