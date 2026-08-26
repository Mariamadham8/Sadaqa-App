/*
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sadaqa_app/core/services/fireStore/user_service.dart';
import 'local_notification_service.dart';

class OneSignalService {
  static const _appId = '8fb15cc2-10f3-4534-bcf5-8f7d6a9fa0ca';

  final UserService _userService;
  final LocalNotificationService _localNotifications;

  OneSignalService({
    required UserService userService,
    required LocalNotificationService localNotifications,
  }) : _userService = userService,
       _localNotifications = localNotifications;

  Future<void> init(String userId) async {
    OneSignal.initialize(_appId);

    // Request permissions
    await OneSignal.Notifications.requestPermission(true);

    // Save player id in Firestore
    final playerId = OneSignal.User.pushSubscription.id;
    if (playerId != null) {
      await _userService.updateOneSignalPlayerId(
        uid: userId,
        playerId: playerId,
      );
    }

    // لو الـ player id اتغير
    OneSignal.User.pushSubscription.addObserver((state) async {
      final newId = state.current.id;
      if (newId != null) {
        await _userService.updateOneSignalPlayerId(
          uid: userId,
          playerId: newId,
        );
      }
    });

    // Foreground notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = event.notification;
      _localNotifications.show(
        title: notification.title ?? '',
        body: notification.body ?? '',
        payload: notification.additionalData?['groupId'],
      );
      event.preventDefault();
    });
  }

  // اشترك في topic جروب
  Future<void> subscribeToGroup(String groupId) async {
    OneSignal.User.addTags({'group_$groupId': 'true'}); // Map
  }

  // إلغاء الاشتراك
  Future<void> unsubscribeFromGroup(String groupId) async {
    OneSignal.User.removeTag('group_$groupId');
  }
}
*/
