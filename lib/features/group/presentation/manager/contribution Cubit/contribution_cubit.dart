import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sadaqa_app/core/utils/cyclic_utils_helper.dart';
import 'package:sadaqa_app/features/group/data/models/contribution_model.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';
import 'package:sadaqa_app/features/group/data/repo/contribution%20repo/contribution_repo.dart';

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

    if (isClosed) return;

    await result.fold(
      (error) async => emit(ContributionFailure(message: error.message)),
      (_) async {
        
        final statusResult = await _repository.getUserStatus(
          userId: userId,
          groupId: groupId,
          month: month,
        );

        if (isClosed) return;

        statusResult.fold(
          (error) => emit(ContributionFailure(message: error.message)),
          (contribution) => emit(StatusLoaded(contribution: contribution)),
        );

        if (isClosed) return;
        emit(PaymentUpdated());
      },
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

  Future<void> getUserStatusesForGroups({
    required String userId,
    required List<GroupModel> groups,
  }) async {
    emit(ContributionLoading());

    final Map<String, bool> paidStatusByGroupId = {};

    for (final group in groups) {
      final cycleKey = CycleUtils.currentCycleKeyForGroup(group.startDate);
      if (cycleKey == null) {
        paidStatusByGroupId[group.id] = false;
        continue;
      }

      final result = await _repository.getUserStatus(
        userId: userId,
        groupId: group.id,
        month: cycleKey,
      );

      result.fold(
        (error) => paidStatusByGroupId[group.id] = false,
        (contribution) =>
            paidStatusByGroupId[group.id] = contribution?.isConfirmed ?? false,
      );
    }

    if (isClosed) return;
    emit(UserStatusesLoaded(paidStatusByGroupId: paidStatusByGroupId));
  }

}
