import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _users => _db.collection('users');

  // Create user after register
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _users.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'fcmToken': '',
      'oneSignalPlayerId': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user by id
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return doc.data() as Map<String, dynamic>;
  }

  // Update FCM token
  Future<void> updateFcmToken({
    required String uid,
    required String token,
  }) async {
    await _users.doc(uid).update({'fcmToken': token});
  }

  // Update OneSignal player id
  Future<void> updateOneSignalPlayerId({
    required String uid,
    required String playerId,
  }) async {
    await _users.doc(uid).update({'oneSignalPlayerId': playerId});
  }
}
