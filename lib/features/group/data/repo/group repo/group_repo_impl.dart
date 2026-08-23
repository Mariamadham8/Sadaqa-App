import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/group/data/data%20source/group_ds.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';
import 'package:sadaqa_app/features/group/data/repo/group%20repo/group-repo.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupDataSource _dataSource;

  GroupRepositoryImpl({required GroupDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<AppError, GroupModel>> createGroup({
    required String adminId,
    required String adminName,
    required String name,
    required double monthlyAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _dataSource.createGroup(
      adminId: adminId,
      adminName: adminName,
      name: name,
      monthlyAmount: monthlyAmount,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Either<AppError, GroupModel>> getGroup(String groupId) {
    return _dataSource.getGroup(groupId);
  }

  @override
  Future<Either<AppError, List<GroupModel>>> getUserGroups(String userId) {
    return _dataSource.getUserGroups(userId);
  }

  @override
  String getInviteLink(String groupId) {
    return _dataSource.getInviteLink(groupId);
  }
}
