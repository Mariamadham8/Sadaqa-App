import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/membership/data/models/membership_model.dart';

abstract class MembershipRepository {
  Future<Either<AppError, Unit>> joinGroup({
    required String userId,
    required String groupId,
    required String userName,
    String role = 'member',
  });

  Future<Either<AppError, List<MembershipModel>>> getGroupMembers(
    String groupId,
  );

  Future<Either<AppError, bool>> checkIsMember({
    required String userId,
    required String groupId,
  });

  Future<Either<AppError, String?>> getUserRole({
    required String userId,
    required String groupId,
  });
}
