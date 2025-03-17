import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/household.dart';

class HouseholdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new household
  Future<Household> createHousehold({
    required String name,
    required String description,
    required String createdBy,
  }) async {
    final now = DateTime.now();
    final household = Household(
      id: '',
      name: name,
      description: description,
      memberIds: [createdBy],
      familyIds: [],
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );

    final docRef = await _firestore.collection('households').add(household.toMap());
    return household.copyWith(id: docRef.id);
  }

  // Get a household by ID
  Future<Household?> getHousehold(String id) async {
    final doc = await _firestore.collection('households').doc(id).get();
    if (!doc.exists) return null;
    return Household.fromMap({...doc.data()!, 'id': doc.id});
  }

  // Get households where user is a member
  Stream<List<Household>> getUserHouseholds(String userId) {
    return _firestore
        .collection('households')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Household.fromMap({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Add a user to a household
  Future<void> addUserToHousehold(String householdId, String userId) async {
    await _firestore.collection('households').doc(householdId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Add a family to a household
  Future<void> addFamilyToHousehold(String householdId, String familyId) async {
    await _firestore.collection('households').doc(householdId).update({
      'familyIds': FieldValue.arrayUnion([familyId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove a user from a household
  Future<void> removeUserFromHousehold(String householdId, String userId) async {
    await _firestore.collection('households').doc(householdId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove a family from a household
  Future<void> removeFamilyFromHousehold(String householdId, String familyId) async {
    await _firestore.collection('households').doc(householdId).update({
      'familyIds': FieldValue.arrayRemove([familyId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update household details
  Future<void> updateHousehold(String householdId, {
    String? name,
    String? description,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;

    await _firestore.collection('households').doc(householdId).update(updates);
  }
} 