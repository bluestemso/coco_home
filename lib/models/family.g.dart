// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Family _$FamilyFromJson(Map<String, dynamic> json) => Family(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      pendingInvitations:
          Map<String, String>.from(json['pendingInvitations'] as Map),
      createdAt: Family._dateTimeFromTimestamp(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$FamilyToJson(Family instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerId': instance.ownerId,
      'memberIds': instance.memberIds,
      'pendingInvitations': instance.pendingInvitations,
      'createdAt': Family._dateTimeToTimestamp(instance.createdAt),
    };
