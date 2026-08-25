import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/core/dependancy%20injection/di.dart';
import 'package:sadaqa_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sadaqa_app/features/auth/presentation/views/login_view.dart';
import 'package:sadaqa_app/features/auth/presentation/views/signup.dart';
import 'package:sadaqa_app/features/group/data/models/group_model.dart';
import 'package:sadaqa_app/features/group/presentation/manager/contribution%20Cubit/contribution_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/manager/group%20cubit/group_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/manager/membership%20Cubit/membership_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/views/group_details_view.dart';
import 'package:sadaqa_app/features/group/presentation/views/home_view.dart';

class AppRouter {
  static const kSpalshview = '/spalsh';
  static const kLoginview = '/login';
  static const kSignupview = '/signup';
  static const home = '/home';
  static const groupDetails = '/GroupDetailsView';
  final GoRouter router = GoRouter(
    routes: [
       GoRoute(path: '/', builder: (context, state) => BlocProvider(
        create: (BuildContext context) =>get<AuthCubit>(), 
        child: SignupView())),
        GoRoute(path: '/spalsh', builder: (context, state) => Center()),
       GoRoute
       (
        path: '/login', 
       builder: (context, state) => BlocProvider
       (
        create: (BuildContext context) =>get<AuthCubit>(),     
       child: LoginView())
       ),
     
      GoRoute(path: '/signup', builder: (context, state) => BlocProvider(
        create: (BuildContext context) =>get<AuthCubit>(), 
        child: SignupView())),

          GoRoute(path: '/home', builder: (context, state) =>MultiBlocProvider(
            providers: [
              BlocProvider(create: (BuildContext context) =>get<GroupCubit>()),
              BlocProvider(create: (BuildContext context) =>get<ContributionCubit>()),
              BlocProvider(create: (BuildContext context) =>get<MembershipCubit>()),
            ],
            child: UserGroupsView(),
          )),

         GoRoute(
  path: '/GroupDetailsView',
  builder: (context, state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => get<GroupCubit>()),
        BlocProvider(create: (context) => get<ContributionCubit>()),
        BlocProvider(create: (context) => get<MembershipCubit>()),
      ],
      child: GroupDetailsView(group: state.extra as GroupModel),
    );
  },
),


    ],
  );
}
