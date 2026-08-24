import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/core/widgets/custom_appbar.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/add_group_boody.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/fab_button.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/groups_listview.dart';
import '../../../../core/utils/app_colors.dart';
import '../manager/group cubit/group_cubit.dart';

class UserGroupsViewBody extends StatefulWidget {
  const UserGroupsViewBody({super.key});

  @override
  State<UserGroupsViewBody> createState() => _UserGroupsViewBodyState();
}

class _UserGroupsViewBodyState extends State<UserGroupsViewBody> {
 @override
void initState() {
  super.initState();
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    context.read<GroupCubit>().loadUserGroups(userId);
  }
}
  void _openAddGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GroupCubit>(),
        child: const AddGroupBoody(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(),
      body:  GroupsListBody(),
      floatingActionButton: CreateGroupFab(
        onTap: () => _openAddGroupDialog(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

