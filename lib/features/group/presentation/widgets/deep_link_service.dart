import 'dart:async';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  final _pendingGroupIdController = StreamController<String?>.broadcast();
  Stream<String?> get pendingGroupIdStream => _pendingGroupIdController.stream;

  String? _pendingGroupId;
  String? get pendingGroupId => _pendingGroupId;

  Future<void> init() async {
    // 1) لو التطبيق كان مقفول تمامًا واتفتح عن طريق اللينك
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) _handleUri(initialUri);

    // 2) لو التطبيق شغال بالفعل (foreground/background) واللينك جه
    _linkSub = _appLinks.uriLinkStream.listen(_handleUri);
  }

  void _handleUri(Uri uri) {
  print('DeepLink received: $uri'); 
  if (uri.host == 'join') {
    final groupId = uri.queryParameters['groupId'];
    print('groupId: $groupId'); 
    if (groupId != null && groupId.isNotEmpty) {
      _pendingGroupId = groupId;
      _pendingGroupIdController.add(groupId);
    }
  }
}

  /// تتنادى بعد ما اليوزر يقفل الديالوج (join أو cancel)، عشان منفضلش
  /// نعرض نفس الدعوة تاني كل مرة الشاشة تتبني.
  void clearPendingGroupId() {
    _pendingGroupId = null;
    _pendingGroupIdController.add(null);
  }

  void dispose() {
    _linkSub?.cancel();
    _pendingGroupIdController.close();
  }
}