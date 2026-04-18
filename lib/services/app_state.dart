import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/special_event.dart';
import '../models/day_item.dart';

class AppState extends ChangeNotifier {
  static const String _ticksKey = 'day_ticks';
  static const String _yearKey = 'ticks_year';

  late DateTime _epochDate;
  DateTime get epochDate => _epochDate;

  /// Map of dayNumber -> color index (0-6)
  Map<int, int> _ticks = {};
  Map<int, int> get ticks => _ticks;

  int _selectedColorIndex = 0;
  int get selectedColorIndex => _selectedColorIndex;

  static const List<Color> availableColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFF9F43), // Orange
    Color(0xFFFECA57), // Yellow
    Color(0xFF48DBFB), // Light Blue
    Color(0xFF0ABDE3), // Blue
    Color(0xFFA29BFE), // Purple
    Color(0xFFFF6BCB), // Pink
  ];

  late List<DayItem> _allDays;
  List<DayItem> get allDays => _allDays;

  int _todayIndex = 0;
  int get todayIndex => _todayIndex;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Epoch is always Jan 1 of the current year
    _epochDate = DateTime(today.year, 1, 1);

    // Load ticks, clearing them if they're from a previous year
    final ticksStr = prefs.getString(_ticksKey);
    final savedYear = prefs.getInt(_yearKey);
    if (ticksStr != null && savedYear == today.year) {
      final Map<String, dynamic> ticksMap = jsonDecode(ticksStr);
      _ticks = ticksMap.map((k, v) => MapEntry(int.parse(k), v as int));
    } else {
      // New year or first launch — clear ticks
      _ticks = {};
      await prefs.setString(_ticksKey, '{}');
      await prefs.setInt(_yearKey, today.year);
    }

    _buildDayList(today);
    _isInitialized = true;
    notifyListeners();
  }

  void _buildDayList(DateTime today) {
    final year = _epochDate.year;
    // End date is Dec 31 of the epoch year
    final endDate = DateTime(year, 12, 31);
    // Start date is the epoch itself (or Jan 1 if epoch is Jan 1)
    final startDate = _epochDate;

    // Collect all special event dates for this year
    final Map<DateTime, SpecialEvent> specialEventMap = {};
    for (final event in SpecialEvent.allEvents) {
      final eventDate = event.dateInYear(year);
      // Only include if the event is within our range
      if (!eventDate.isBefore(startDate) && !eventDate.isAfter(endDate)) {
        final normalized = DateTime(eventDate.year, eventDate.month, eventDate.day);
        specialEventMap[normalized] = event;
      }
    }

    _allDays = [];
    DateTime current = startDate;
    while (!current.isAfter(endDate)) {
      final dayNumber = current.difference(_epochDate).inDays;
      final normalized = DateTime(current.year, current.month, current.day);
      final event = specialEventMap[normalized];

      if (event != null) {
        // Add the special event card (replaces the regular chip)
        _allDays.add(DayItem(
          date: current,
          dayNumber: dayNumber,
          eventName: event.name,
          eventImageAsset: event.imageAsset,
          eventVideoAsset: event.videoAsset,
          isSpecialEvent: true,
        ));
      } else {
        // Regular day chip
        _allDays.add(DayItem(
          date: current,
          dayNumber: dayNumber,
        ));
      }

      current = current.add(const Duration(days: 1));
    }

    // Find today's index for initial scroll position
    final todayDayNumber = today.difference(_epochDate).inDays;
    _todayIndex = _allDays.indexWhere((d) => d.dayNumber == todayDayNumber);
    if (_todayIndex < 0) _todayIndex = 0;
  }

  void selectColor(int index) {
    _selectedColorIndex = index;
    notifyListeners();
  }

  bool canTick(int dayNumber) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayDayNumber = today.difference(_epochDate).inDays;
    return dayNumber <= todayDayNumber;
  }

  bool isTicked(int dayNumber) {
    return _ticks.containsKey(dayNumber);
  }

  int? getTickColorIndex(int dayNumber) {
    return _ticks[dayNumber];
  }

  Future<void> toggleTick(int dayNumber) async {
    if (!canTick(dayNumber)) return;

    if (_ticks.containsKey(dayNumber)) {
      _ticks.remove(dayNumber);
    } else {
      _ticks[dayNumber] = _selectedColorIndex;
    }

    // Persist
    final prefs = await SharedPreferences.getInstance();
    final ticksMap = _ticks.map((k, v) => MapEntry(k.toString(), v));
    await prefs.setString(_ticksKey, jsonEncode(ticksMap));

    notifyListeners();
  }
}
