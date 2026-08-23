import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sadaqa_app/core/error/app_error.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';
import 'package:sadaqa_app/features/group/data/repo/group%20repo/group-repo.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository _repository;
  GroupCubit(this._repository) : super(GroupInitial());

  Future<void> createGroup({
    required String adminId,
    required String adminName,
    required String name,
    required double monthlyAmount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(GroupLoading());

    final result = await _repository.createGroup(
      adminId: adminId,
      adminName: adminName,
      name: name,
      monthlyAmount: monthlyAmount,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (error) => emit(GroupFailure(error)),
      (group) => emit(GroupCreated(group)),
    );
  }

  Future<void> loadGroup(String groupId) async {
    emit(GroupLoading());

    final result = await _repository.getGroup(groupId);

    result.fold(
      (error) => emit(GroupFailure(error)),
      (group) => emit(GroupLoaded(group)),
    );
  }

  Future<void> loadUserGroups(String userId) async {
    emit(GroupLoading());

    final result = await _repository.getUserGroups(userId);
    debugPrint('Current user: ${FirebaseAuth.instance.currentUser?.uid}');
    result.fold(
      (error) => emit(GroupFailure(error)),
      (groups) => emit(UserGroupsLoaded(groups)),
    );
  }

  String getInviteLink(String groupId) {
    return _repository.getInviteLink(groupId);
  }
}
