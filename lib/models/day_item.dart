import 'package:flutter/material.dart';

/// Represents a single item in the day list - either a regular day or a special event day.
class DayItem {
  final DateTime date;
  final int dayNumber; // relative to epoch (negative = past, 0 = epoch, positive = future)
  final String? eventName;
  final String? eventImageAsset;
  final String? eventVideoAsset;
  final bool isSpecialEvent;

  const DayItem({
    required this.date,
    required this.dayNumber,
    this.eventName,
    this.eventImageAsset,
    this.eventVideoAsset,
    this.isSpecialEvent = false,
  });
}

/// Tick data for a specific day - which color it was ticked with.
class DayTick {
  final int dayNumber;
  final Color color;

  const DayTick({required this.dayNumber, required this.color});
}
