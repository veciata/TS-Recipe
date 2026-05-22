import 'dart:io' show Platform, Process;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';

class UrlLauncherService {
  static const _channel = MethodChannel('app.url_launcher');

  static Future<bool> canLaunch(String url) async {
    return Uri.tryParse(url) != null;
  }

  static Future<void> launch(String url, {bool external = false}) async {
    if (!await canLaunch(url)) return;

    if (external) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          await _channel.invokeMethod('launchUrl', url);
          return;
        } catch (_) {}
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await _channel.invokeMethod('launchUrl', url);
          return;
        } catch (_) {}
      }
    }

    if (Platform.isLinux) {
      await Process.run('xdg-open', [url]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [url]);
    } else if (Platform.isWindows) {
      await Process.run('start', [url]);
    }
  }
}
