import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family.dart';

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new family
  Future<Family> createFamily({
    required String name,
    required String description,
    required String createdBy,
  }) async {
    final now = DateTime.now();
    final docRef = await _firestore.collection('families').add({
      'name': name,
      'description': description,
      'memberIds': [createdBy],
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });

    // Get the created document to return
    final doc = await docRef.get();
    return Family.fromMap({...doc.data()!, 'id': doc.id});
  }

  // Get a family by ID
  Future<Family?> getFamily(String id) async {
    final doc = await _firestore.collection('families').doc(id).get();
    if (!doc.exists) return null;
    return Family.fromMap({...doc.data()!, 'id': doc.id});
  }

  // Get families where user is a member
  Stream<List<Family>> getUserFamilies(String userId) {
    return _firestore
        .collection('families')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Family.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Add a user to a family
  Future<void> addUserToFamily(String familyId, String userId) async {
    await _firestore.collection('families').doc(familyId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove a user from a family
  Future<void> removeUserFromFamily(String familyId, String userId) async {
    await _firestore.collection('families').doc(familyId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update family details
  Future<void> updateFamily(String familyId, {
    String? name,
    String? description,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;

    await _firestore.collection('families').doc(familyId).update(updates);
  }
} 