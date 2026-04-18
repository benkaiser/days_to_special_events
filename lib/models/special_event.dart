class SpecialEvent {
  final String name;
  final String imageAsset;
  final String? videoAsset;
  final int month; // 1-12
  final int day; // 1-31
  final bool isFixedDate; // false for Easter which varies

  const SpecialEvent({
    required this.name,
    required this.imageAsset,
    this.videoAsset,
    required this.month,
    required this.day,
    this.isFixedDate = true,
  });

  /// Get the date of this event in a given year.
  DateTime dateInYear(int year) {
    if (name == 'Easter') {
      return _calculateEaster(year);
    }
    return DateTime(year, month, day);
  }

  /// Compute Easter Sunday using the Anonymous Gregorian algorithm.
  static DateTime _calculateEaster(int year) {
    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = ((h + l - 7 * m + 114) % 31) + 1;
    return DateTime(year, month, day);
  }

  static const List<SpecialEvent> allEvents = [
    SpecialEvent(
      name: "Penelope's Birthday",
      imageAsset: 'assets/images/penelope.png',
      videoAsset: 'assets/videos/penelope_video_cropped.mp4',
      month: 5,
      day: 28,
    ),
    SpecialEvent(
      name: 'Christmas',
      imageAsset: 'assets/images/christmas.png',
      videoAsset: 'assets/videos/christmas_generated.mp4',
      month: 12,
      day: 25,
    ),
    SpecialEvent(
      name: "New Year's Eve",
      imageAsset: 'assets/images/new_years_eve.png',
      videoAsset: 'assets/videos/new_years_eve_generated.mp4',
      month: 12,
      day: 31,
    ),
    SpecialEvent(
      name: "New Year's Day",
      imageAsset: 'assets/images/new_years_day.png',
      videoAsset: 'assets/videos/new_years_day_generated.mp4',
      month: 1,
      day: 1,
    ),
    SpecialEvent(
      name: "Valentine's Day",
      imageAsset: 'assets/images/valentines.png',
      videoAsset: 'assets/videos/valentines_generated.mp4',
      month: 2,
      day: 14,
    ),
    SpecialEvent(
      name: 'Easter',
      imageAsset: 'assets/images/easter.png',
      videoAsset: 'assets/videos/easter_generated.mp4',
      month: 4, // approximate, actual date computed
      day: 1,
      isFixedDate: false,
    ),
    SpecialEvent(
      name: "Dad's Birthday",
      imageAsset: 'assets/images/dad.png',
      videoAsset: 'assets/videos/dad_generated.mp4',
      month: 5,
      day: 26,
    ),
    SpecialEvent(
      name: "Mum's Birthday",
      imageAsset: 'assets/images/mum.png',
      videoAsset: 'assets/videos/mum_generated.mp4',
      month: 3,
      day: 7,
    ),
    SpecialEvent(
      name: "Sia's Birthday",
      imageAsset: 'assets/images/sia.png',
      videoAsset: 'assets/videos/sia_generated.mp4',
      month: 9,
      day: 7,
    ),
    SpecialEvent(
      name: "Caspian's Birthday",
      imageAsset: 'assets/images/caspian.png',
      videoAsset: 'assets/videos/caspian_generated.mp4',
      month: 1,
      day: 4,
    ),
    SpecialEvent(
      name: "Nanny's Birthday",
      imageAsset: 'assets/images/nanny.png',
      videoAsset: 'assets/videos/nanny_generated.mp4',
      month: 8,
      day: 29,
    ),
    SpecialEvent(
      name: "Opa's Birthday",
      imageAsset: 'assets/images/opa.png',
      videoAsset: 'assets/videos/opa_generated.mp4',
      month: 6,
      day: 11,
    ),
    SpecialEvent(
      name: "Malee's Birthday",
      imageAsset: 'assets/images/malee.png',
      videoAsset: 'assets/videos/malee_generated.mp4',
      month: 9,
      day: 29,
    ),
    SpecialEvent(
      name: "Dave's Birthday",
      imageAsset: 'assets/images/dave.png',
      videoAsset: 'assets/videos/dave_generated.mp4',
      month: 10,
      day: 17,
    ),
    SpecialEvent(
      name: "Jordan's Birthday",
      imageAsset: 'assets/images/jordan.png',
      videoAsset: 'assets/videos/jordan_generated.mp4',
      month: 7,
      day: 20,
    ),
    SpecialEvent(
      name: "Natalie's Birthday",
      imageAsset: 'assets/images/natalie.png',
      videoAsset: 'assets/videos/natalie_video_cropped.mp4',
      month: 11,
      day: 12,
    ),
    SpecialEvent(
      name: "Charlie's Birthday",
      imageAsset: 'assets/images/charlie.png',
      videoAsset: 'assets/videos/charlie_generated.mp4',
      month: 3,
      day: 17,
    ),
    SpecialEvent(
      name: "Alfie's Birthday",
      imageAsset: 'assets/images/alfie.png',
      videoAsset: 'assets/videos/alfie_generated.mp4',
      month: 2,
      day: 20,
    ),
  ];
}
