import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/core/dependancy injection/di.dart';
import 'package:sadaqa_app/core/router/app_router.dart';
import 'package:sadaqa_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/manager/membership Cubit/membership_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/deep_link_service.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/group_invitation_dialog.dart';


class PendingInviteGate extends StatefulWidget {
  const PendingInviteGate({super.key, required this.child});
  final Widget child;

  @override
  State<PendingInviteGate> createState() => _PendingInviteGateState();
}

class _PendingInviteGateState extends State<PendingInviteGate> {
  StreamSubscription<String?>? _linkSub;
  StreamSubscription<AuthState>? _authSub;
  bool _dialogOpen = false;
  bool _redirectedForInvite = false; // منمنعش تكرار التوجيه لصفحة اللوجين

  @override
  void initState() {
    super.initState();

    final deepLinkService = get<DeepLinkService>();
    final authCubit = context.read<AuthCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDialog());

    _linkSub = deepLinkService.pendingGroupIdStream.listen((_) => _maybeShowDialog());
    _authSub = authCubit.stream.listen((_) => _maybeShowDialog());
  }

  void _maybeShowDialog() {
    if (_dialogOpen) return;

    final authState = context.read<AuthCubit>().state;
    final groupId = get<DeepLinkService>().pendingGroupId;

    // مفيش دعوة معلقة أصلًا، مفيش داعي نعمل حاجة
    if (groupId == null) {
      _redirectedForInvite = false;
      return;
    }

    final navContext = AppRouter.navigatorKey.currentContext;
    if (navContext == null) return;

    if (authState is AuthAuthenticated) {
      _redirectedForInvite = false;
      _dialogOpen = true;
      showDialog<void>(
        context: navContext,
        builder: (_) => BlocProvider(
          create: (_) => get<MembershipCubit>(),
          child: JoinGroupDialog(groupId: groupId),
        ),
      ).then((_) {
        _dialogOpen = false;
        get<DeepLinkService>().clearPendingGroupId();
      });
      return;
    }

   
    if (!_redirectedForInvite) {
      _redirectedForInvite = true;
      ScaffoldMessenger.of(navContext).showSnackBar(
        const SnackBar(content: Text('login to join the group')),
      );
      navContext.go(AppRouter.kLoginview);
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}