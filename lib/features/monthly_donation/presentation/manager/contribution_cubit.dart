import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sadaqa_app/features/monthly_donation/data/models/contribution_model.dart';
import 'package:sadaqa_app/features/monthly_donation/data/repo/contribution_repo.dart';

part 'contribution_state.dart';

class ContributionCubit extends Cubit<ContributionState> {
  final ContributionRepository _repository;
  ContributionCubit(this._repository) : super(ContributionInitial());

  Future<void> getUserStatus({
    required String userId,
    required String groupId,
    String? month,
  }) async {
    emit(ContributionLoading());

    final result = await _repository.getUserStatus(
      userId: userId,
      groupId: groupId,
      month: month,
    );

    result.fold(
      (error) => emit(ContributionFailure(message: error.message)),
      (contribution) => emit(StatusLoaded(contribution: contribution)),
    );
  }

  Future<void> updatePayment({
    required String userId,
    required String groupId,
    required double amount,
    String? month,
  }) async {
    emit(ContributionLoading());

    final result = await _repository.updatePayment(
      userId: userId,
      groupId: groupId,
      amount: amount,
      month: month,
    );

    result.fold(
      (error) => emit(ContributionFailure(message: error.message)),
      (_) => emit(PaymentUpdated()),
    );
  }

  Future<void> getGroupContributions({
    required String groupId,
    String? month,
  }) async {
    emit(ContributionLoading());

    final contributionsResult = await _repository.getGroupContributions(
      groupId: groupId,
      month: month,
    );

    contributionsResult.fold(
      (error) => emit(ContributionFailure(message: error.message)),
      (contributions) async {
        final totalResult = await _repository.getTotalCollected(
          groupId: groupId,
          month: month,
        );

        totalResult.fold(
          (error) => emit(ContributionFailure(message: error.message)),
          (total) => emit(
            GroupContributionsLoaded(
              contributions: contributions,
              totalCollected: total,
            ),
          ),
        );
      },
    );
  }

  Future<void> getTotalCollected({
    required String groupId,
    String? month,
  }) async {
    emit(ContributionLoading());

    final result = await _repository.getTotalCollected(
      groupId: groupId,
      month: month,
    );

    result.fold(
      (error) => emit(ContributionFailure(message: error.message)),
      (total) => emit(TotalCollectedLoaded(total: total)),
    );
  }
}
