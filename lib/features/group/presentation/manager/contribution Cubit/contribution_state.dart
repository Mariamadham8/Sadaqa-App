part of 'contribution_cubit.dart';

@immutable
abstract class ContributionState {}

class ContributionInitial extends ContributionState {}

class ContributionLoading extends ContributionState {
  ContributionLoading();
}

class StatusLoaded extends ContributionState {
  final ContributionModel? contribution;

  StatusLoaded({required this.contribution});

  bool get hasPaid => contribution?.isConfirmed ?? false;
}

class PaymentUpdated extends ContributionState {
  PaymentUpdated();
}

class GroupContributionsLoaded extends ContributionState {
  final List<ContributionModel> contributions;
  final double totalCollected;

  GroupContributionsLoaded({
    required this.contributions,
    required this.totalCollected,
  });

  int get confirmedCount => contributions.where((c) => c.isConfirmed).length;

  int get pendingCount => contributions.where((c) => c.isPending).length;
}

class TotalCollectedLoaded extends ContributionState {
  final double total;

  TotalCollectedLoaded({required this.total});
}

class ContributionFailure extends ContributionState {
  final String message;

  ContributionFailure({required this.message});
}

class UserStatusesLoaded extends ContributionState {
  final Map<String, bool> paidStatusByGroupId;
  UserStatusesLoaded({required this.paidStatusByGroupId});
}
