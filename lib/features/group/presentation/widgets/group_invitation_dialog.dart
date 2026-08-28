import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadaqa_app/core/dependancy injection/di.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';
import 'package:sadaqa_app/features/group/data/repo/group repo/group-repo.dart';
import 'package:sadaqa_app/features/group/presentation/manager/group cubit/group_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/manager/membership Cubit/membership_cubit.dart';

class JoinGroupDialog extends StatefulWidget {
  const JoinGroupDialog({super.key, required this.groupId});
  final String groupId;

  @override
  State<JoinGroupDialog> createState() => _JoinGroupDialogState();
}

class _JoinGroupDialogState extends State<JoinGroupDialog> {
  GroupModel? _group;
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _fetchGroup();
  }

  Future<void> _fetchGroup() async {
    final result = await get<GroupRepository>().getGroup(widget.groupId);
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _loading = false;
        _loadError = error.message;
      }),
      (group) => setState(() {
        _loading = false;
        _group = group;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => get<MembershipCubit>(),
      child: BlocConsumer<MembershipCubit, MembershipState>(
      
        listenWhen: (previous, current) =>
            previous.joined != current.joined ||
            previous.joinError != current.joinError,
        listener: (context, state) {
          if (state.joined) {
            final userId = FirebaseAuth.instance.currentUser!.uid;
            get<GroupCubit>().loadUserGroups(userId); 
            Navigator.of(context).pop();
          } else if (state.joinError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.joinError!)),
            );
          }
        },
        builder: (context, state) {
          final isJoining = state.isJoining;

          return AlertDialog(
            title: const Text('دعوة انضمام'),
            content: _buildContent(),
            actions: [
              TextButton(
                onPressed: isJoining ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: (_group == null || isJoining) ? null : () => _join(context),
                child: isJoining
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Join'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null) {
      return Text('The group is not available: $_loadError');
    }

    return Text('Do you want to join the group "${_group!.name}"？');
  }

  void _join(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    context.read<MembershipCubit>().joinGroup(
      groupId: widget.groupId,
      userId: user.uid,
      userName: user.displayName ?? '',
    );
  }
}