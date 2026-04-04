import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HapticsManager {
  static Future<void> light() async {
    if (kIsWeb) return; // Completely bypass on web to avoid Pigeon errors
    try {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.light);
      }
    } catch (e) {
      // Safe fallback
    }
  }

  static Future<void> medium() async {
    if (kIsWeb) return;
    try {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.medium);
      }
    } catch (e) {
      // Safe fallback
    }
  }

  static Future<void> heavy() async {
    if (kIsWeb) return;
    try {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.heavy);
      }
    } catch (e) {
      // Safe fallback
    }
  }

  static Future<void> success() async {
    if (kIsWeb) return;
    try {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.success);
      }
    } catch (e) {
      // Safe fallback
    }
  }

  static Future<void> error() async {
    if (kIsWeb) return;
    try {
      if (await Vibrate.canVibrate) {
        Vibrate.feedback(FeedbackType.error);
      }
    } catch (e) {
      // Safe fallback
    }
  }
}
