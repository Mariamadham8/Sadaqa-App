import 'package:cloud_firestore/cloud_firestore.dart';

class ContributionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _contributions =>
      _db.collection('monthlyContributions');

  // Get current month string e.g. "2026-06"
  String get currentMonth {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  // Get current month status for a user in a group
  Future<Map<String, dynamic>?> getUserMonthlyStatus({
    required String userId,
    required String groupId,
    String? month,
  }) async {
    final snap = await _contributions
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .where('month', isEqualTo: month ?? currentMonth)
        .get();

    if (snap.docs.isEmpty) return null;
    return {
      'id': snap.docs.first.id,
      ...snap.docs.first.data() as Map<String, dynamic>,
    };
  }

  // Get all contributions for a group this month
  Future<List<Map<String, dynamic>>> getGroupMonthlyContributions({
    required String groupId,
    String? month,
  }) async {
    final snap = await _contributions
        .where('groupId', isEqualTo: groupId)
        .where('month', isEqualTo: month ?? currentMonth)
        .get();

    return snap.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  // Update payment status (member confirms payment)
  Future<void> updatePaymentStatus({
    required String userId,
    required String groupId,
    required double amount,
    String? month,
  }) async {
    final snap = await _contributions
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .where('month', isEqualTo: month ?? currentMonth)
        .get();

    if (snap.docs.isEmpty) {
      // Create new record if not exists
      await _contributions.doc().set({
        'userId': userId,
        'groupId': groupId,
        'month': month ?? currentMonth,
        'status': 'confirmed',
        'amount': amount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await snap.docs.first.reference.update({
        'status': 'confirmed',
        'amount': amount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Get total collected for a group this month
  Future<double> getTotalCollected({
    required String groupId,
    String? month,
  }) async {
    final contributions = await getGroupMonthlyContributions(
      groupId: groupId,
      month: month,
    );

    return contributions
        .where((c) => c['status'] == 'confirmed')
        .fold<double>(0.0, (sum, c) => sum + (c['amount'] as num).toDouble());
  }
}
