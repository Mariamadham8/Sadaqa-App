/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sadaqa_app/core/services/fireStore/user_service.dart';
import 'local_notification_service.dart';

class OneSignalService {
  static const _appId = '8fb15cc2-10f3-4534-bcf5-8f7d6a9fa0ca';
  static const _restApiKey = 'PASTE_YOUR_REST_API_KEY_HERE';

  final UserService _userService;
  final LocalNotificationService _localNotifications;

  OneSignalService({
    required UserService userService,
    required LocalNotificationService localNotifications,
  }) : _userService = userService,
       _localNotifications = localNotifications;

  Future<void> init(String userId) async {
    OneSignal.initialize(_appId);
    await OneSignal.Notifications.requestPermission(true);

    final playerId = OneSignal.User.pushSubscription.id;
    if (playerId != null) {
      await _userService.updateOneSignalPlayerId(uid: userId, playerId: playerId);
    }

    OneSignal.User.pushSubscription.addObserver((state) async {
      final newId = state.current.id;
      if (newId != null) {
        await _userService.updateOneSignalPlayerId(uid: userId, playerId: newId);
      }
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final notification = event.notification;
      _localNotifications.show(
        title: notification.title ?? '',
        body: notification.body ?? '',
        payload: notification.additionalData?['groupId']?.toString(),
      );
      event.preventDefault();
    });
  }

  /// تذكير لشخص واحد بس - بتجيب الـ player id بتاعه من فايرستور الأول
  Future<void> sendReminder({
    required String targetUserId,
    required String groupName,
  }) async {
    final user = await _userService.getUser(targetUserId);
    final playerId = user?['oneSignalPlayerId'] as String?;

    if (playerId == null || playerId.isEmpty) {
      throw Exception('المستخدم ده لسه معندوش إشعارات مفعّلة');
    }

    final response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $_restApiKey',
      },
      body: jsonEncode({
        'app_id': _appId,
        'include_player_ids': [playerId],
        'headings': {'en': groupName, 'ar': groupName},
        'contents': {
          'en': 'Reminder: please pay your monthly contribution',
          'ar': 'تذكير: من فضلك ادفع اشتراكك الشهري',
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send reminder: ${response.body}');
    }
  }

  Future<void> subscribeToGroup(String groupId) async {
    OneSignal.User.addTags({'group_$groupId': 'true'});
  }

  Future<void> unsubscribeFromGroup(String groupId) async {
    OneSignal.User.removeTag('group_$groupId');
  }
}
*/