import 'package:cloud_firestore/cloud_firestore.dart';

class Household {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds; // User IDs
  final List<String> familyIds; // Family IDs
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Household({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.familyIds,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'description': description,
      'memberIds': memberIds,
      'familyIds': familyIds,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
    
    // Only include id if it's not empty (for existing documents)
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    
    return map;
  }

  factory Household.fromMap(Map<String, dynamic> map) {
    return Household(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      familyIds: List<String>.from(map['familyIds'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Household copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? memberIds,
    List<String>? familyIds,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Household(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberIds: memberIds ?? this.memberIds,
      familyIds: familyIds ?? this.familyIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 