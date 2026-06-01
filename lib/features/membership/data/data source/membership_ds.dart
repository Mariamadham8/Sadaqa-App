import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/core/services/fireStore/membership_service.dart';
import 'package:sadaqa_app/features/membership/data/models/membership_model.dart';

class MembershipDataSource {
  final MembershipService _membershipService;

  MembershipDataSource({required MembershipService membershipService})
    : _membershipService = membershipService;

  Future<Either<AppError, Unit>> joinGroup({
    required String userId,
    required String groupId,
    required String userName,
    String role = 'member',
  }) async {
    try {
      await _membershipService.joinGroup(
        userId: userId,
        groupId: groupId,
        userName: userName,
        role: role,
      );
      return right(unit);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }

  Future<Either<AppError, List<MembershipModel>>> getGroupMembers(
    String groupId,
  ) async {
    try {
      final rawList = await _membershipService.getGroupMembers(groupId);
      final members = rawList
          .map((map) => MembershipModel.fromMap(map))
          .toList();
      return right(members);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }

  Future<Either<AppError, bool>> checkIsMember({
    required String userId,
    required String groupId,
  }) async {
    try {
      final result = await _membershipService.isMember(
        userId: userId,
        groupId: groupId,
      );
      return right(result);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }

  Future<Either<AppError, String?>> getUserRole({
    required String userId,
    required String groupId,
  }) async {
    try {
      final role = await _membershipService.getUserRole(
        userId: userId,
        groupId: groupId,
      );
      return right(role);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }
}
