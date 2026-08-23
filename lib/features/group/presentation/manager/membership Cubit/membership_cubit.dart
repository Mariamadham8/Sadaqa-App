import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sadaqa_app/features/group/data/models/membership_model.dart';
import 'package:sadaqa_app/features/group/data/repo/membership%20repo/membership_repo.dart';

part 'membership_state.dart';

class MembershipCubit extends Cubit<MembershipState> {
  final MembershipRepository _repository;
  MembershipCubit(this._repository) : super(MembershipInitial());

  Future<void> joinGroup({
    required String userId,
    required String groupId,
    required String userName,
    String role = 'member',
  }) async {
    emit(MembershipLoading());

    final result = await _repository.joinGroup(
      userId: userId,
      groupId: groupId,
      userName: userName,
      role: role,
    );

    result.fold(
      (error) => emit(MembershipFailure(message: error.message)),
      (_) => emit(MembershipJoined()),
    );
  }

  Future<void> getGroupMembers(String groupId) async {
    emit(MembershipLoading());

    final result = await _repository.getGroupMembers(groupId);

    result.fold(
      (error) => emit(MembershipFailure(message: error.message)),
      (members) => emit(MembersLoaded(members: members)),
    );
  }

  Future<void> checkIsMember({
    required String userId,
    required String groupId,
  }) async {
    emit(MembershipLoading());

    final result = await _repository.checkIsMember(
      userId: userId,
      groupId: groupId,
    );

    result.fold(
      (error) => emit(MembershipFailure(message: error.message)),
      (isMember) => emit(MembershipChecked(isMember: isMember)),
    );
  }
}
