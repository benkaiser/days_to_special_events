import 'package:flutter/material.dart';
import '../models/day_item.dart';
import '../services/app_state.dart';
import '../widgets/color_selector.dart';
import '../widgets/day_chip.dart';
import '../widgets/special_event_card.dart';
import '../widgets/rainbow_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppState _appState = AppState();
  late ScrollController _scrollController;
  bool _hasScrolledToToday = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});

    // Scroll to today on first load
    if (_appState.isInitialized && !_hasScrolledToToday) {
      _hasScrolledToToday = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToToday();
      });
    }
  }

  void _scrollToToday() {
    // We need to estimate the position. Each regular chip row has ~4-5 items.
    // Special events are taller. We'll use the item index approach.
    // Since we use a SliverList, we can estimate based on todayIndex.
    final todayIdx = _appState.todayIndex;
    // Rough estimation: count items before todayIdx
    // Group regular items into rows of chipsPerRow
    double estimatedOffset = 0;
    int chipCount = 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final chipsPerRow = ((screenWidth - 24) / 80).floor().clamp(1, 10);

    for (int i = 0; i < todayIdx && i < _appState.allDays.length; i++) {
      if (_appState.allDays[i].isSpecialEvent) {
        // Flush any pending chips
        if (chipCount > 0) {
          final rows = (chipCount / chipsPerRow).ceil();
          estimatedOffset += rows * 80;
          chipCount = 0;
        }
        estimatedOffset += 156; // card height + margin
      } else {
        chipCount++;
      }
    }
    if (chipCount > 0) {
      final rows = (chipCount / chipsPerRow).ceil();
      estimatedOffset += rows * 80;
    }

    // Subtract some to show today in context
    estimatedOffset = (estimatedOffset - 200).clamp(0.0, double.infinity);

    _scrollController.animateTo(
      estimatedOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_appState.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      body: RainbowGlitterBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Penelope's Special Days",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              // Color selector
              ColorSelector(appState: _appState),
              const Divider(color: Colors.white24, height: 1),
              // Scrollable day list
              Expanded(
                child: _buildDayList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayList(BuildContext context) {
    // Build groups: contiguous regular days become chip grids,
    // special events are full-width cards.
    final groups = _buildGroups();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        if (group.isSpecialEvent) {
          return SpecialEventCard(
            dayItem: group.items.first,
            appState: _appState,
          );
        } else {
          // Render a grid of day chips
          return _buildChipGrid(group.items, context);
        }
      },
    );
  }

  Widget _buildChipGrid(List<DayItem> items, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: items.map((item) {
          return DayChip(dayItem: item, appState: _appState);
        }).toList(),
      ),
    );
  }

  List<_DayGroup> _buildGroups() {
    final groups = <_DayGroup>[];
    List<DayItem> currentChips = [];

    for (final day in _appState.allDays) {
      if (day.isSpecialEvent) {
        if (currentChips.isNotEmpty) {
          groups.add(_DayGroup(items: List.of(currentChips), isSpecialEvent: false));
          currentChips.clear();
        }
        groups.add(_DayGroup(items: [day], isSpecialEvent: true));
      } else {
        currentChips.add(day);
      }
    }
    if (currentChips.isNotEmpty) {
      groups.add(_DayGroup(items: currentChips, isSpecialEvent: false));
    }

    return groups;
  }
}

class _DayGroup {
  final List<DayItem> items;
  final bool isSpecialEvent;

  _DayGroup({required this.items, required this.isSpecialEvent});
}
