import 'package:flutter_test/flutter_test.dart';
import 'package:tamanga/domain/models.dart';
import 'package:tamanga/domain/passport_rules.dart';

void main() {
  group('passport stamp rules', () {
    test('does not duplicate event or province stamp for the same source', () {
      final results = [
        result(id: 'one', eventId: 'event-a'),
        result(id: 'two', eventId: 'event-a'),
      ];

      final stamps = PassportRules.deriveStamps(results);

      expect(
        stamps.where((stamp) => stamp.type == StampType.event),
        hasLength(1),
      );
      expect(
        stamps.where((stamp) => stamp.type == StampType.province),
        hasLength(1),
      );
      expect(
        stamps,
        everyElement(
          isA<PassportStamp>().having(
            (stamp) => stamp.isProvisional,
            'provisional',
            true,
          ),
        ),
      );
    });
  });

  group('distance thresholds', () {
    test('uses tolerance for real-world race recordings', () {
      expect(PassportRules.distanceCategory(4.86), 5);
      expect(PassportRules.distanceCategory(10.34), 10);
      expect(PassportRules.distanceCategory(20.7), 21.1);
      expect(PassportRules.distanceCategory(8.0), isNull);
    });

    test('awards a first-distance milestone only once', () {
      final achievements = PassportRules.deriveAchievements([
        result(id: 'one', distance: 5.02),
        result(id: 'two', distance: 4.96, day: 2),
      ]);

      expect(
        achievements.where(
          (item) => item.type == AchievementType.distanceMilestone,
        ),
        hasLength(1),
      );
    });
  });

  group('repeat counts', () {
    test('groups only configured distance categories', () {
      final counts = PassportRules.repeatCounts([
        result(id: 'one', distance: 15),
        result(id: 'two', distance: 15.2),
        result(id: 'three', distance: 8),
      ]);

      expect(counts[15], 2);
      expect(counts.containsKey(8), isFalse);
    });

    test(
      'creates a fifth-repeat achievement separately from first distance',
      () {
        final results = List.generate(
          5,
          (index) => result(id: '$index', distance: 10, day: index + 1),
        );
        final achievements = PassportRules.deriveAchievements(results);

        expect(
          achievements.where(
            (item) => item.type == AchievementType.distanceMilestone,
          ),
          hasLength(1),
        );
        expect(
          achievements.where(
            (item) => item.type == AchievementType.repeatDistance,
          ),
          hasLength(1),
        );
        expect(achievements.last.title, '5 × 10 km');
      },
    );
  });

  group('event-price filters', () {
    final organizer = const Organizer(id: 'org', name: 'Organizer');
    late List<RaceEvent> events;

    setUp(() {
      events = [
        event(
          id: 'free',
          price: const EventPrice(status: PriceStatus.free),
          organizer: organizer,
        ),
        event(
          id: 'paid',
          price: const EventPrice(status: PriceStatus.paid, amountZmw: 100),
          organizer: organizer,
        ),
        event(
          id: 'unknown',
          price: const EventPrice(status: PriceStatus.unknown),
          organizer: organizer,
        ),
      ];
    });

    test('free does not include unknown-price events', () {
      final filtered = PassportRules.filterEvents(
        events,
        const EventFilter(priceStatus: PriceStatus.free),
      );
      expect(filtered.map((item) => item.id), ['free']);
    });

    test('paid and unknown remain distinct', () {
      expect(
        PassportRules.filterEvents(
          events,
          const EventFilter(priceStatus: PriceStatus.paid),
        ).single.id,
        'paid',
      );
      expect(
        PassportRules.filterEvents(
          events,
          const EventFilter(priceStatus: PriceStatus.unknown),
        ).single.id,
        'unknown',
      );
    });
  });
}

RaceResult result({
  required String id,
  double distance = 5,
  int day = 1,
  String? eventId,
}) => RaceResult(
  id: id,
  name: 'Test finish',
  date: DateTime(2026, 1, day),
  distanceKm: distance,
  durationMinutes: 30,
  province: Province.lusaka,
  verification: VerificationStatus.selfReported,
  source: 'test',
  eventId: eventId,
);

RaceEvent event({
  required String id,
  required EventPrice price,
  required Organizer organizer,
}) => RaceEvent(
  id: id,
  name: id,
  province: Province.lusaka,
  venue: 'Test venue',
  startAt: DateTime(2026, 10, 1),
  distances: const [EventDistance(id: '5k', kilometres: 5)],
  price: price,
  organizer: organizer,
  registrationDeadline: DateTime(2026, 9, 25),
  source: 'test',
  lastUpdated: DateTime(2026, 9, 1),
);
