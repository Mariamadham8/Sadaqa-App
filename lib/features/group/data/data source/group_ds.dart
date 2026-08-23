import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/core/services/fireStore/group_service.dart';
import 'package:sadaqa_app/core/services/fireStore/membership_service.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';

class GroupDataSource {
  final GroupService _groupService;
  final MembershipService _membershipService;

  GroupDataSource({
    required GroupService groupService,
    required MembershipService membershipService,
  }) : _groupService = groupService,
       _membershipService = membershipService;

  // Create group + add admin as first member
  Future<Either<AppError, GroupModel>> createGroup({
    required String adminId,
    required String adminName,
    required String name,
    required double monthlyAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final groupId = await _groupService.createGroup(
        adminId: adminId,
        name: name,
        monthlyAmount: monthlyAmount,
        startDate: startDate,
        endDate: endDate,
      );

      // Add admin as first member with role 'admin'
      await _membershipService.joinGroup(
        userId: adminId,
        groupId: groupId,
        userName: adminName,
        role: 'admin',
      );

      final groupData = await _groupService.getGroup(groupId);
      return Right(GroupModel.fromMap(groupId, groupData!));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied')
        return const Left(PermissionDeniedError());
      return const Left(UnknownError());
    } catch (_) {
      return const Left(UnknownError());
    }
  }

  // Get group by id
  Future<Either<AppError, GroupModel>> getGroup(String groupId) async {
    try {
      final data = await _groupService.getGroup(groupId);
      if (data == null) return const Left(NotFoundError());
      return Right(GroupModel.fromMap(groupId, data));
    } catch (_) {
      return const Left(UnknownError());
    }
  }

 // Get all groups for a user
Future<Either<AppError, List<GroupModel>>> getUserGroups(
  String userId,
) async {
  try {
    final groups = await _groupService.getUserGroups(userId);
    final models = groups.map((g) => GroupModel.fromMap(g['id'], g)).toList();
    return Right(models);
  } on FirebaseException catch (e, st) {
    debugPrint('[getUserGroups] FirebaseException: ${e.code} → ${e.message}');
    debugPrint('$st');
    if (e.code == 'permission-denied') {
      return const Left(PermissionDeniedError());
    }
    return const Left(UnknownError());
  } catch (e, st) {
    debugPrint('[getUserGroups] Unknown error: $e');
    debugPrint('$st');
    return const Left(UnknownError());
  }
}

  // Get invite link
  String getInviteLink(String groupId) {
    return _groupService.generateInviteLink(groupId);
  }
}
