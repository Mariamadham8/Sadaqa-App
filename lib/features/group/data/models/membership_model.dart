import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipModel {
  final String id;
  final String userId;
  final String groupId;
  final String name;
  final String role;
  final DateTime? joinedAt;

  const MembershipModel({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    required this.role,
    this.joinedAt,
  });

  factory MembershipModel.fromMap(Map<String, dynamic> map) {
    return MembershipModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      groupId: map['groupId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? 'member',
      joinedAt: map['joinedAt'] is Timestamp
          ? (map['joinedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'groupId': groupId,
      'name': name,
      'role': role,
      'joinedAt': joinedAt != null ? Timestamp.fromDate(joinedAt!) : null,
    };
  }

  MembershipModel copyWith({
    String? id,
    String? userId,
    String? groupId,
    String? name,
    String? role,
    DateTime? joinedAt,
  }) {
    return MembershipModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  bool get isAdmin => role == 'admin';

  @override
  String toString() =>
      'MembershipModel(id: $id, userId: $userId, groupId: $groupId, name: $name, role: $role)';
}
