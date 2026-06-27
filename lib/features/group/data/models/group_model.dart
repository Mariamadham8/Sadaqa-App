import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String adminId;
  final String adminName;
  final String name;
  final String discriptoin;
  final double monthlyAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String inviteLink;
  final DateTime? createdAt;
  final String adminContact;
  final String paymentMethod;

  const GroupModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.monthlyAmount,
    required this.startDate,
    required this.endDate,
    required this.inviteLink,
    this.createdAt,
    this.adminName = '',
    this.discriptoin = '',
    this.adminContact = '',
    this.paymentMethod = '',
  });

  factory GroupModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      adminId: map['adminId'] ?? '',
      adminName: map['adminName'] ?? '',
      name: map['name'] ?? '',
      discriptoin: map['discriptoin'] ?? '',
      monthlyAmount: (map['monthlyAmount'] as num).toDouble(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      inviteLink: map['inviteLink'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      adminContact: map['adminContact'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
    };
  }

  bool get isActive => DateTime.now().isBefore(endDate);
}
