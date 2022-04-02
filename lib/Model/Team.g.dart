// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      leader: Member.fromJson(json['leader'] as Map<String, dynamic>),
      session: Session.fromJson(json['session'] as Map<String, dynamic>),
      teamName: json['teamName'] as String,
      songs: (json['songs'] as List<dynamic>).map((e) => e as String).toList(),
      teamID: json['teamID'] as String?,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'leader': instance.leader.toJson(),
      'session': instance.session.toJson(),
      'teamName': instance.teamName,
      'songs': instance.songs,
      'teamID': instance.teamID,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      guitar: (json['guitar'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      piano: (json['piano'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      vocal: (json['vocal'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      bass: (json['bass'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      drum: (json['drum'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      other: (json['other'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Member.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'guitar': instance.guitar.map((e) => e.toJson()).toList(),
      'piano': instance.piano.map((e) => e.toJson()).toList(),
      'vocal': instance.vocal.map((e) => e.toJson()).toList(),
      'bass': instance.bass.map((e) => e.toJson()).toList(),
      'drum': instance.drum.map((e) => e.toJson()).toList(),
      'other': instance.other.map((k, e) => MapEntry(k, e.toJson())),
    };
