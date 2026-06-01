import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _memberships => _db.collection('memberships');

  // Join group
  Future<void> joinGroup({
    required String userId,
    required String groupId,
    required String userName,
    String role = 'member',
  }) async {
    // Check if already a member
    final existing = await _memberships
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .get();

    if (existing.docs.isNotEmpty) return; // already joined

    await _memberships.doc().set({
      'userId': userId,
      'groupId': groupId,
      'name': userName,
      'role': role,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all members of a group
  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    final snap = await _memberships.where('groupId', isEqualTo: groupId).get();

    return snap.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  // Check if user is member
  Future<bool> isMember({
    required String userId,
    required String groupId,
  }) async {
    final snap = await _memberships
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .get();

    return snap.docs.isNotEmpty;
  }

  // Get user role in group
  Future<String?> getUserRole({
    required String userId,
    required String groupId,
  }) async {
    final snap = await _memberships
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .get();

    if (snap.docs.isEmpty) return null;
    return (snap.docs.first.data() as Map<String, dynamic>)['role'] as String?;
  }
}
