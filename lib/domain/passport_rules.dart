import 'models.dart';

class PassportRules {
  static const milestoneDistances = <double>[5, 10, 15, 21.1, 42.2];

  static double? distanceCategory(double distanceKm) {
    for (final milestone in milestoneDistances) {
      final tolerance = milestone == 42.2
          ? 0.7
          : (milestone * 0.035).clamp(0.2, 0.5);
      if ((distanceKm - milestone).abs() <= tolerance) return milestone;
    }
    return null;
  }

  static List<RaceEvent> filterEvents(
    List<RaceEvent> events,
    EventFilter filter,
  ) {
    return events.where((event) {
      final provinceMatches =
          filter.province == null || event.province == filter.province;
      final priceMatches =
          filter.priceStatus == null ||
          event.price.status == filter.priceStatus;
      final dateMatches =
          filter.fromDate == null || !event.startAt.isBefore(filter.fromDate!);
      final distanceMatches =
          filter.distanceKm == null ||
          event.distances.any(
            (distance) =>
                distanceCategory(distance.kilometres) == filter.distanceKm,
          );
      return provinceMatches && priceMatches && dateMatches && distanceMatches;
    }).toList();
  }

  static Map<double, int> repeatCounts(List<RaceResult> results) {
    final counts = <double, int>{};
    for (final result in results) {
      final category = distanceCategory(result.distanceKm);
      if (category != null) counts[category] = (counts[category] ?? 0) + 1;
    }
    return counts;
  }

  static List<Achievement> deriveAchievements(List<RaceResult> results) {
    final sorted = [...results]..sort((a, b) => a.date.compareTo(b.date));
    final counts = <double, int>{};
    final achievements = <Achievement>[];
    for (final result in sorted) {
      final category = distanceCategory(result.distanceKm);
      if (category == null) continue;
      final count = (counts[category] ?? 0) + 1;
      counts[category] = count;
      final label = _distanceLabel(category);
      if (count == 1) {
        achievements.add(
          Achievement(
            id: 'first-${category.toString()}-${result.id}',
            type: AchievementType.distanceMilestone,
            title: 'First $label',
            description: 'Your first recorded $label finish.',
            sourceResultId: result.id,
          ),
        );
      }
      if (<int>{5, 10, 25, 50, 100}.contains(count)) {
        achievements.add(
          Achievement(
            id: 'repeat-$count-${category.toString()}-${result.id}',
            type: AchievementType.repeatDistance,
            title: '$count × $label',
            description: 'Your ${_ordinal(count)} recorded $label finish.',
            sourceResultId: result.id,
          ),
        );
      }
    }
    return achievements;
  }

  static List<PassportStamp> deriveStamps(List<RaceResult> results) {
    final stamps = <PassportStamp>[];
    final seen = <String>{};
    for (final result in results) {
      final eventKey = 'event:${result.eventId ?? result.id}';
      if (seen.add(eventKey)) {
        stamps.add(
          PassportStamp(
            id: eventKey,
            type: StampType.event,
            title: result.name,
            sourceResultId: result.id,
            verification: result.verification,
            earnedAt: result.date,
            criteria:
                'Recorded participation in this event. Self-reported records stay provisional.',
          ),
        );
      }
      final provinceKey = 'province:${result.province.name}';
      if (seen.add(provinceKey)) {
        stamps.add(
          PassportStamp(
            id: provinceKey,
            type: StampType.province,
            title: result.province.label,
            sourceResultId: result.id,
            verification: result.verification,
            earnedAt: result.date,
            criteria:
                'First recorded event in ${result.province.label}. Pilot eligibility is provisional.',
          ),
        );
      }
    }
    return stamps;
  }

  static String _distanceLabel(double distance) =>
      '${distance.toStringAsFixed(distance % 1 == 0 ? 0 : 1)} km';

  static String _ordinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) return '${number}th';
    return switch (number % 10) {
      1 => '${number}st',
      2 => '${number}nd',
      3 => '${number}rd',
      _ => '${number}th',
    };
  }
}
