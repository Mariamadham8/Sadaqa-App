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
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) handleUri(initialUri);

    _linkSub = _appLinks.uriLinkStream.listen(handleUri);
  }

  /// عامة دلوقتي عشان go_router يقدر ينادّيها مباشرة من الـ redirect
  /// بيدعم الشكلين: custom scheme (host == join) و https (path == /join)
  void handleUri(Uri uri) {
    print('DeepLink received: $uri');
    final isJoinLink = uri.host == 'join' || uri.path == '/join';
    if (!isJoinLink) return;

    final groupId = uri.queryParameters['groupId'];
    print('groupId: $groupId');
    if (groupId != null && groupId.isNotEmpty) {
      _pendingGroupId = groupId;
      _pendingGroupIdController.add(groupId);
    }
  }

  void clearPendingGroupId() {
    _pendingGroupId = null;
    _pendingGroupIdController.add(null);
  }

  void dispose() {
    _linkSub?.cancel();
    _pendingGroupIdController.close();
  }
}