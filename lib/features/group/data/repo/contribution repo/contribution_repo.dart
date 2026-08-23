import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/group/data/models/contribution_model.dart';

abstract class ContributionRepository {
  Future<Either<AppError, ContributionModel?>> getUserStatus({
    required String userId,
    required String groupId,
    String? month,
  });

  Future<Either<AppError, Unit>> updatePayment({
    required String userId,
    required String groupId,
    required double amount,
    String? month,
  });

  Future<Either<AppError, List<ContributionModel>>> getGroupContributions({
    required String groupId,
    String? month,
  });

  Future<Either<AppError, double>> getTotalCollected({
    required String groupId,
    String? month,
  });
}
