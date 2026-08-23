import 'package:dartz/dartz.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/group/data/data%20source/contribution_ds.dart';
import 'package:sadaqa_app/features/group/data/models/contribution_model.dart';
import 'package:sadaqa_app/features/group/data/repo/contribution%20repo/contribution_repo.dart';

class ContributionRepositoryImpl implements ContributionRepository {
  final ContributionDataSource _dataSource;

  ContributionRepositoryImpl({required ContributionDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<AppError, ContributionModel?>> getUserStatus({
    required String userId,
    required String groupId,
    String? month,
  }) {
    return _dataSource.getUserStatus(
      userId: userId,
      groupId: groupId,
      month: month,
    );
  }

  @override
  Future<Either<AppError, Unit>> updatePayment({
    required String userId,
    required String groupId,
    required double amount,
    String? month,
  }) {
    return _dataSource.updatePayment(
      userId: userId,
      groupId: groupId,
      amount: amount,
      month: month,
    );
  }

  @override
  Future<Either<AppError, List<ContributionModel>>> getGroupContributions({
    required String groupId,
    String? month,
  }) {
    return _dataSource.getGroupContributions(groupId: groupId, month: month);
  }

  @override
  Future<Either<AppError, double>> getTotalCollected({
    required String groupId,
    String? month,
  }) {
    return _dataSource.getTotalCollected(groupId: groupId, month: month);
  }
}
