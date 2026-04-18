import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/day_item.dart';
import '../services/app_state.dart';

class SpecialEventCard extends StatefulWidget {
  final DayItem dayItem;
  final AppState appState;

  const SpecialEventCard({
    super.key,
    required this.dayItem,
    required this.appState,
  });

  @override
  State<SpecialEventCard> createState() => _SpecialEventCardState();
}

class _SpecialEventCardState extends State<SpecialEventCard> {
  VideoPlayerController? _videoController;
  bool _showingVideo = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleVideo() {
    if (widget.dayItem.eventVideoAsset == null) return;

    if (_showingVideo) {
      _videoController?.pause();
      _videoController?.dispose();
      _videoController = null;
      setState(() => _showingVideo = false);
    } else {
      _videoController = VideoPlayerController.asset(widget.dayItem.eventVideoAsset!)
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            setState(() => _showingVideo = true);
            _videoController!.play();
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysUntil = widget.dayItem.date.difference(today).inDays;
    final isPast = daysUntil < 0;
    final dayNum = widget.dayItem.dayNumber;
    final canTick = widget.appState.canTick(dayNum);
    final isTicked = widget.appState.isTicked(dayNum);
    final tickColorIndex = widget.appState.getTickColorIndex(dayNum);
    final hasVideo = widget.dayItem.eventVideoAsset != null;

    return Container(
      width: double.infinity,
      height: _showingVideo ? 200 : 140,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background layer — tapping toggles video
            GestureDetector(
              onTap: _toggleVideo,
              behavior: HitTestBehavior.opaque,
              child: _showingVideo &&
                      _videoController != null &&
                      _videoController!.value.isInitialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  : Opacity(
                      opacity: 0.35,
                      child: Image.asset(
                        widget.dayItem.eventImageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.purple.withValues(alpha: 0.3),
                            child: const Icon(Icons.celebration,
                                color: Colors.white54, size: 60),
                          );
                        },
                      ),
                    ),
            ),
            // Gradient overlay
            if (!_showingVideo)
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            // Ticked color overlay
            if (isTicked && !_showingVideo)
              IgnorePointer(
                child: Container(
                  color: AppState.availableColors[tickColorIndex!]
                      .withValues(alpha: 0.25),
                ),
              ),
            // Content overlay
            if (!_showingVideo)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Tick indicator
                    if (isTicked)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.check_circle,
                          color: AppState.availableColors[tickColorIndex!],
                          size: 28,
                        ),
                      ),
                    // Event name and status — tapping this area toggles video
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleVideo,
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.dayItem.eventName!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 4,
                                            color: Colors.black54),
                                      ],
                                    ),
                                  ),
                                ),
                                if (hasVideo) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.play_circle_outline,
                                    color:
                                        Colors.white.withValues(alpha: 0.7),
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isPast
                                  ? '${-daysUntil} days ago'
                                  : daysUntil == 0
                                      ? "It's today!"
                                      : '$daysUntil day${daysUntil == 1 ? '' : 's'} to go!',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Big countdown number — tap to tick/untick
                    GestureDetector(
                      onTap: canTick
                          ? () => widget.appState.toggleTick(dayNum)
                          : null,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTicked
                              ? AppState.availableColors[tickColorIndex!]
                                  .withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: isTicked
                                ? AppState.availableColors[tickColorIndex!]
                                : canTick
                                    ? const Color(0xFFFFD700)
                                    : Colors.white.withValues(alpha: 0.5),
                            width: isTicked || canTick ? 3 : 2,
                          ),
                        ),
                        child: Center(
                          child: isTicked
                              ? Icon(
                                  Icons.check,
                                  color: AppState
                                      .availableColors[tickColorIndex!],
                                  size: 36,
                                )
                              : Text(
                                  daysUntil == 0
                                      ? '🎉'
                                      : daysUntil.abs().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        daysUntil.abs() > 99 ? 24 : 32,
                                    fontWeight: FontWeight.w900,
                                    shadows: const [
                                      Shadow(
                                          blurRadius: 4,
                                          color: Colors.black54),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Close button when video is playing
            if (_showingVideo)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _toggleVideo,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
            // Event name overlay when video is playing
            if (_showingVideo)
              Positioned(
                bottom: 8,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.dayItem.eventName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Gold border for tickable unticked events
            if (canTick && !isTicked && !_showingVideo)
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 3,
                    ),
                  ),
                ),
              ),
            // Sparkle border for upcoming events (within 7 days)
            if (!isPast && !canTick && daysUntil <= 7 && !_showingVideo)
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
