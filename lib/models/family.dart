import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds; // User IDs
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Family({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'description': description,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
    
    // Only include id if it's not empty (i.e., for existing documents)
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    
    return map;
  }

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Family copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? memberIds,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Family(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 