import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sadaqa_app/features/group/data/models/membership_model.dart';
import 'package:sadaqa_app/features/group/data/repo/membership%20repo/membership_repo.dart';

part 'membership_state.dart';

class MembershipCubit extends Cubit<MembershipState> {
  final MembershipRepository _repository;
  MembershipCubit(this._repository) : super(const MembershipState());

  Future<void> joinGroup({
    required String userId,
    required String groupId,
    required String userName,
    String role = 'member',
  }) async {
    emit(state.copyWith(isJoining: true, joinError: null));

    final result = await _repository.joinGroup(
      userId: userId,
      groupId: groupId,
      userName: userName,
      role: role,
    );

    result.fold(
      (error) => emit(state.copyWith(isJoining: false, joinError: error.message)),
      (_) => emit(state.copyWith(isJoining: false, joined: true)),
    );
  }

  Future<void> getGroupMembers(String groupId) async {
    emit(state.copyWith(isLoadingMembers: true, membersError: null));

    final result = await _repository.getGroupMembers(groupId);

    result.fold(
      (error) => emit(state.copyWith(isLoadingMembers: false, membersError: error.message)),
      (members) => emit(state.copyWith(isLoadingMembers: false, members: members)),
    );
  }

  Future<void> checkIsMember({
    required String userId,
    required String groupId,
  }) async {
    emit(state.copyWith(isCheckingMembership: true, checkError: null));

    final result = await _repository.checkIsMember(
      userId: userId,
      groupId: groupId,
    );

    result.fold(
      (error) => emit(state.copyWith(isCheckingMembership: false, checkError: error.message)),
      (isMember) => emit(state.copyWith(isCheckingMembership: false, isMember: isMember)),
    );
  }

  Future<void> getUserRole({
    required String userId,
    required String groupId,
  }) async {
    emit(state.copyWith(isLoadingRole: true, roleError: null));

    final result = await _repository.getUserRole(
      userId: userId,
      groupId: groupId,
    );

    result.fold(
      (error) => emit(state.copyWith(isLoadingRole: false, roleError: error.message)),
      (role) => emit(state.copyWith(isLoadingRole: false, role: role)),
    );
  }
}