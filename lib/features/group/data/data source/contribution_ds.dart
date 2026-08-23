import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/core/services/fireStore/contribution_service.dart';
import 'package:sadaqa_app/features/group/data/models/contribution_model.dart';

class ContributionDataSource {
  final ContributionService _contributionService;

  ContributionDataSource({required ContributionService contributionService})
    : _contributionService = contributionService;

  Future<Either<AppError, ContributionModel?>> getUserStatus({
    required String userId,
    required String groupId,
    String? month,
  }) async {
    try {
      final map = await _contributionService.getUserMonthlyStatus(
        userId: userId,
        groupId: groupId,
        month: month,
      );
      final model = map != null ? ContributionModel.fromMap(map) : null;
      return right(model);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }

  Future<Either<AppError, Unit>> updatePayment({
    required String userId,
    required String groupId,
    required double amount,
    String? month,
  }) async {
    try {
      await _contributionService.updatePaymentStatus(
        userId: userId,
        groupId: groupId,
        amount: amount,
        month: month,
      );
      return right(unit);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }

  Future<Either<AppError, List<ContributionModel>>> getGroupContributions({
    required String groupId,
    String? month,
  }) async {
    try {
      final rawList = await _contributionService.getGroupMonthlyContributions(
        groupId: groupId,
        month: month,
      );
      final contributions = rawList
          .map((map) => ContributionModel.fromMap(map))
          .toList();
      return right(contributions);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }

  Future<Either<AppError, double>> getTotalCollected({
    required String groupId,
    String? month,
  }) async {
    try {
      final total = await _contributionService.getTotalCollected(
        groupId: groupId,
        month: month,
      );
      return right(total);
    } catch (e) {
      return left(AppError(e.toString()));
    }
  }
}
