part of 'group_cubit.dart';

@immutable
abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {
  GroupLoading();
}

// Group created successfully
class GroupCreated extends GroupState {
  final GroupModel group;
  GroupCreated(this.group);
}

// Group loaded
class GroupLoaded extends GroupState {
  final GroupModel group;
  GroupLoaded(this.group);
}

class UserGroupsLoaded extends GroupState {
  final List<GroupModel> groups;
  UserGroupsLoaded(this.groups);
}

class GroupFailure extends GroupState {
  final AppError error;
  GroupFailure(this.error);
}
