import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _groups => _db.collection('groups');

  // Generate invite link from groupId
  String generateInviteLink(String groupId) {
    return 'sadaqaapp://join?groupId=$groupId';
  }

  // Create group
  Future<String> createGroup({
    required String adminId,
    required String adminName,
    required String name,
    required double monthlyAmount,
    required DateTime startDate,
    required DateTime endDate,
    String discriptoin = '',
    String adminContact = '',
    String paymentMethod = '',
  }) async {
    final ref = _groups.doc();
    final inviteLink = generateInviteLink(ref.id);

    await ref.set({
      'adminId': adminId,
      'adminName': adminName,
      'name': name,
      'discriptoin': discriptoin,
      'monthlyAmount': monthlyAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'inviteLink': inviteLink,
      'adminContact': adminContact,
      'paymentMethod': paymentMethod,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return ref.id;
  }

  // Get group by id
  Future<Map<String, dynamic>?> getGroup(String groupId) async {
    final doc = await _groups.doc(groupId).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
  }

  // Get all groups for a user (via memberships)
  Future<List<Map<String, dynamic>>> getUserGroups(String userId) async {
    final memberships = await _db
        .collection('memberships')
        .where('userId', isEqualTo: userId)
        .get();

    final List<Map<String, dynamic>> groups = [];

    for (final doc in memberships.docs) {
      final groupId = doc.data()['groupId'];
      final group = await getGroup(groupId);
      if (group != null) groups.add(group);
    }

    return groups;
  }
}