import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantSettings {
  final String adminNote;
  final bool isManualOverride; // If true, use isManuallyOpen
  final bool isManuallyOpen;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  RestaurantSettings({
    required this.adminNote,
    required this.isManualOverride,
    required this.isManuallyOpen,
    required this.openingTime,
    required this.closingTime,
  });

  RestaurantSettings copyWith({
    String? adminNote,
    bool? isManualOverride,
    bool? isManuallyOpen,
    TimeOfDay? openingTime,
    TimeOfDay? closingTime,
  }) {
    return RestaurantSettings(
      adminNote: adminNote ?? this.adminNote,
      isManualOverride: isManualOverride ?? this.isManualOverride,
      isManuallyOpen: isManuallyOpen ?? this.isManuallyOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }

  bool get isOpen {
    if (isManualOverride) return isManuallyOpen;

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = openingTime.hour * 60 + openingTime.minute;
    final closeMinutes = closingTime.hour * 60 + closingTime.minute;

    if (closeMinutes > openMinutes) {
      return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
    } else {
      // Overnight (e.g. 10 AM to 2 AM)
      return nowMinutes >= openMinutes || nowMinutes < closeMinutes;
    }
  }
}

class RestaurantSettingsNotifier extends StateNotifier<RestaurantSettings> {
  RestaurantSettingsNotifier()
      : super(RestaurantSettings(
          adminNote: '',
          isManualOverride: false,
          isManuallyOpen: true,
          openingTime: const TimeOfDay(hour: 9, minute: 0),
          closingTime: const TimeOfDay(hour: 23, minute: 0),
        ));

  void updateNote(String note) => state = state.copyWith(adminNote: note);
  
  void setManualStatus(bool isOpen) {
    state = state.copyWith(isManualOverride: true, isManuallyOpen: isOpen);
  }

  void resetToAuto() {
    state = state.copyWith(isManualOverride: false);
  }

  void setOpeningTime(TimeOfDay time) => state = state.copyWith(openingTime: time);
  void setClosingTime(TimeOfDay time) => state = state.copyWith(closingTime: time);
}

final restaurantProvider = StateNotifierProvider<RestaurantSettingsNotifier, RestaurantSettings>((ref) {
  return RestaurantSettingsNotifier();
});
