part of 'membership_cubit.dart';

@immutable
abstract class MembershipState {}

class MembershipInitial extends MembershipState {}

class MembershipLoading extends MembershipState {
  MembershipLoading();
}

class MembershipJoined extends MembershipState {
  MembershipJoined();
}

class MembersLoaded extends MembershipState {
  final List<MembershipModel> members;

  MembersLoaded({required this.members});
}

class MembershipChecked extends MembershipState {
  final bool isMember;

  MembershipChecked({required this.isMember});
}

class MembershipFailure extends MembershipState {
  final String message;

  MembershipFailure({required this.message});
}
