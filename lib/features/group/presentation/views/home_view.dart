import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/core/dependancy%20injection/di.dart';
import 'package:sadaqa_app/features/group/presentation/manager/group%20cubit/group_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/user_groups_body.dart';

class UserGroupsView extends StatelessWidget {
  const UserGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<GroupCubit>(),
      child: const UserGroupsViewBody(),
    );
  }
}
