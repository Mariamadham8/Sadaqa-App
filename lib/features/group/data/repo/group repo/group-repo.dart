import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';

abstract class GroupRepository {
  Future<Either<AppError, GroupModel>> createGroup({
    required String adminId,
    required String adminName,
    required String name,
    required double monthlyAmount,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<AppError, GroupModel>> getGroup(String groupId);

  Future<Either<AppError, List<GroupModel>>> getUserGroups(String userId);

  String getInviteLink(String groupId);
}
