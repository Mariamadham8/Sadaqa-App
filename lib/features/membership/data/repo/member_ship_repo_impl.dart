import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/membership/data/data%20source/membership_ds.dart';
import 'package:sadaqa_app/features/membership/data/models/membership_model.dart';
import 'package:sadaqa_app/features/membership/data/repo/membership_repo.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  final MembershipDataSource _dataSource;

  MembershipRepositoryImpl({required MembershipDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<AppError, Unit>> joinGroup({
    required String userId,
    required String groupId,
    required String userName,
    String role = 'member',
  }) {
    return _dataSource.joinGroup(
      userId: userId,
      groupId: groupId,
      userName: userName,
      role: role,
    );
  }

  @override
  Future<Either<AppError, List<MembershipModel>>> getGroupMembers(
    String groupId,
  ) {
    return _dataSource.getGroupMembers(groupId);
  }

  @override
  Future<Either<AppError, bool>> checkIsMember({
    required String userId,
    required String groupId,
  }) {
    return _dataSource.checkIsMember(userId: userId, groupId: groupId);
  }

  @override
  Future<Either<AppError, String?>> getUserRole({
    required String userId,
    required String groupId,
  }) {
    return _dataSource.getUserRole(userId: userId, groupId: groupId);
  }
}
