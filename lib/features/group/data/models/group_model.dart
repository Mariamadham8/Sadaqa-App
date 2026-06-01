import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String adminId;
  final String name;
  final double monthlyAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String inviteLink;
  final DateTime? createdAt;

  const GroupModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.monthlyAmount,
    required this.startDate,
    required this.endDate,
    required this.inviteLink,
    this.createdAt,
  });

  factory GroupModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      adminId: map['adminId'] ?? '',
      name: map['name'] ?? '',
      monthlyAmount: (map['monthlyAmount'] as num).toDouble(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      inviteLink: map['inviteLink'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adminId': adminId,
      'name': name,
      'monthlyAmount': monthlyAmount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'inviteLink': inviteLink,
    };
  }

  bool get isActive => DateTime.now().isBefore(endDate);
}
