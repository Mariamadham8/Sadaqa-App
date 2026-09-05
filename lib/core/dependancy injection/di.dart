import 'package:get_it/get_it.dart';
import 'package:sadaqa_app/core/services/auth/firebase_auth_servide.dart';
import 'package:sadaqa_app/core/services/fcm%20service/local_notification_service.dart';
import 'package:sadaqa_app/core/services/fcm%20service/onsignal_notfication_service.dart';
import 'package:sadaqa_app/core/services/fireStore/user_service.dart';
import 'package:sadaqa_app/core/services/fireStore/group_service.dart';
import 'package:sadaqa_app/core/services/fireStore/membership_service.dart';
import 'package:sadaqa_app/core/services/fireStore/contribution_service.dart';
import 'package:sadaqa_app/features/auth/data/data source/auth_ds.dart';
import 'package:sadaqa_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sadaqa_app/features/group/data/data source/group_ds.dart';
import 'package:sadaqa_app/features/group/presentation/manager/group%20cubit/group_cubit.dart';
import 'package:sadaqa_app/features/group/data/data%20source/membership_ds.dart';
import 'package:sadaqa_app/features/group/data/repo/membership%20repo/member_ship_repo_impl.dart';
import 'package:sadaqa_app/features/group/data/repo/membership%20repo/membership_repo.dart';
import 'package:sadaqa_app/features/auth/data/repos/auth_repo.dart';
import 'package:sadaqa_app/features/group/data/repo/group%20repo/group-repo.dart';
import 'package:sadaqa_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:sadaqa_app/features/group/data/repo/group%20repo/group_repo_impl.dart';
import 'package:sadaqa_app/features/group/presentation/manager/membership%20Cubit/membership_cubit.dart';
import 'package:sadaqa_app/features/group/data/data%20source/contribution_ds.dart';
import 'package:sadaqa_app/features/group/data/repo/contribution%20repo/contribution-repo_impl.dart';
import 'package:sadaqa_app/features/group/data/repo/contribution%20repo/contribution_repo.dart';
import 'package:sadaqa_app/features/group/presentation/manager/contribution%20Cubit/contribution_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/deep_link_service.dart';

GetIt get = GetIt.instance;

void setupLocator() {
  // ─── Services ───────────────────────────────────────────
  get.registerLazySingleton(() => FirebaseAuthService());
  get.registerLazySingleton(() => UserService());
  get.registerLazySingleton(() => GroupService());
  get.registerLazySingleton(() => MembershipService());
  get.registerLazySingleton(() => ContributionService());
  //get.registerLazySingleton(() => LocalNotificationService());

  // ─── Data Sources ────────────────────────────────────────
  get.registerLazySingleton(
    () => AuthDataSource(authService: get(), userService: get()),
  );
  get.registerLazySingleton(
    () => GroupDataSource(groupService: get(), membershipService: get()),
  );
  get.registerLazySingleton(
    () => MembershipDataSource(membershipService: get()),
  );
  get.registerLazySingleton(
    () => ContributionDataSource(contributionService: get()),
  );

  // ─── Repositories ────────────────────────────────────────
  get.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: get()),
  );
  get.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(dataSource: get()),
  );
  get.registerLazySingleton<MembershipRepository>(
    () => MembershipRepositoryImpl(dataSource: get()),
  );
  get.registerLazySingleton<ContributionRepository>(
    () => ContributionRepositoryImpl(dataSource: get()),
  );

  // ─── Cubits ──────────────────────────────────────────────
  get.registerFactory(() => AuthCubit(get()));
  get.registerFactory(() => GroupCubit(get()));
  get.registerFactory(() => MembershipCubit(get()));
  get.registerFactory(() => ContributionCubit(get()));

  get.registerLazySingleton<DeepLinkService>(() => DeepLinkService());

/*
  get.registerLazySingleton(() => LocalNotificationService());
get.registerLazySingleton(
  () => OneSignalService(userService: get(), localNotifications: get()),
);
*/

}
