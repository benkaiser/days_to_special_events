import 'package:flutter/material.dart';
import '../models/day_item.dart';
import '../services/app_state.dart';

class DayChip extends StatefulWidget {
  final DayItem dayItem;
  final AppState appState;

  const DayChip({super.key, required this.dayItem, required this.appState});

  @override
  State<DayChip> createState() => _DayChipState();
}

class _DayChipState extends State<DayChip> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayNum = widget.dayItem.dayNumber;
    final canTick = widget.appState.canTick(dayNum);
    final isTicked = widget.appState.isTicked(dayNum);
    final tickColorIndex = widget.appState.getTickColorIndex(dayNum);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayDayNumber = today.difference(widget.appState.epochDate).inDays;
    final isToday = dayNum == todayDayNumber;

    // Display number relative to today: negative = past, 0 = today, positive = future
    final displayNumber = dayNum - todayDayNumber;

    return GestureDetector(
      onTap: canTick ? () => widget.appState.toggleTick(dayNum) : null,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Container(
            width: 72,
            height: 72,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isTicked
                  ? AppState.availableColors[tickColorIndex!].withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBorderColor(canTick, isTicked, isToday, tickColorIndex),
                width: (canTick && !isTicked) ? 2.5 : (isToday ? 2.5 : 1.5),
              ),
              boxShadow: (canTick && !isTicked)
                  ? [
                      BoxShadow(
                        color: _getGoldShimmer(),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isTicked)
                  Icon(
                    Icons.check_circle,
                    color: AppState.availableColors[tickColorIndex!],
                    size: 20,
                  ),
                Text(
                  displayNumber.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTicked ? 16 : 20,
                    fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getBorderColor(bool canTick, bool isTicked, bool isToday, int? tickColorIndex) {
    if (isTicked) {
      return AppState.availableColors[tickColorIndex!];
    }
    if (isToday) {
      return Colors.white;
    }
    if (canTick) {
      return _getGoldShimmer();
    }
    return Colors.white24;
  }

  Color _getGoldShimmer() {
    // Shimmer between gold shades
    final t = _shimmerController.value;
    final shimmerValue = (0.5 + 0.5 * (t * 3.14159 * 2).clamp(-1.0, 1.0));
    return Color.lerp(
      const Color(0xFFFFD700),
      const Color(0xFFFFF8DC),
      (shimmerValue > 1.0 ? 2.0 - shimmerValue : shimmerValue).clamp(0.0, 1.0),
    )!;
  }
}
