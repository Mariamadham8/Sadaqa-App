import 'package:cloud_firestore/cloud_firestore.dart';

class ContributionModel {
  final String id;
  final String userId;
  final String groupId;
  final String month;
  final String status;
  final double amount;
  final DateTime? updatedAt;

  const ContributionModel({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.month,
    required this.status,
    required this.amount,
    this.updatedAt,
  });

  factory ContributionModel.fromMap(Map<String, dynamic> map) {
    return ContributionModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      groupId: map['groupId'] as String? ?? '',
      month: map['month'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'groupId': groupId,
      'month': month,
      'status': status,
      'amount': amount,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ContributionModel copyWith({
    String? id,
    String? userId,
    String? groupId,
    String? month,
    String? status,
    double? amount,
    DateTime? updatedAt,
  }) {
    return ContributionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      month: month ?? this.month,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isConfirmed => status == 'confirmed';
  bool get isPending => status == 'pending';

  @override
  String toString() =>
      'ContributionModel(id: $id, userId: $userId, groupId: $groupId, month: $month, status: $status, amount: $amount)';
}
