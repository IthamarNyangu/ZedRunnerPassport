enum Province {
  central('Central'),
  copperbelt('Copperbelt'),
  eastern('Eastern'),
  luapula('Luapula'),
  lusaka('Lusaka'),
  muchinga('Muchinga'),
  northern('Northern'),
  northWestern('North-Western'),
  southern('Southern'),
  western('Western');

  const Province(this.label);
  final String label;
}

enum PriceStatus { free, paid, unknown }

enum VerificationStatus {
  selfReported('Self-reported'),
  eventCheckIn('Event check-in'),
  organizerVerified('Organizer verified');

  const VerificationStatus(this.label);
  final String label;
}

enum StampType { event, province, challenge }

enum AchievementType { distanceMilestone, repeatDistance, personalBest }

class EventDistance {
  const EventDistance({required this.id, required this.kilometres, this.label});

  final String id;
  final double kilometres;
  final String? label;

  String get displayLabel =>
      label ?? '${kilometres.toStringAsFixed(kilometres % 1 == 0 ? 0 : 1)} km';
}

class Organizer {
  const Organizer({
    required this.id,
    required this.name,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final bool isVerified;
}

class EventPrice {
  const EventPrice({required this.status, this.amountZmw});

  final PriceStatus status;
  final int? amountZmw;

  String get label => switch (status) {
    PriceStatus.free => 'Free',
    PriceStatus.paid =>
      amountZmw == null ? 'Paid · price not provided' : 'K$amountZmw',
    PriceStatus.unknown => 'Price not provided',
  };
}

class RaceEvent {
  const RaceEvent({
    required this.id,
    required this.name,
    required this.province,
    required this.venue,
    required this.startAt,
    required this.distances,
    required this.price,
    required this.organizer,
    required this.registrationDeadline,
    required this.source,
    required this.lastUpdated,
    this.description = '',
  });

  final String id;
  final String name;
  final Province province;
  final String venue;
  final DateTime startAt;
  final List<EventDistance> distances;
  final EventPrice price;
  final Organizer organizer;
  final DateTime registrationDeadline;
  final String source;
  final DateTime lastUpdated;
  final String description;
}

class RaceResult {
  const RaceResult({
    required this.id,
    required this.name,
    required this.date,
    required this.distanceKm,
    required this.durationMinutes,
    required this.province,
    required this.verification,
    required this.source,
    this.eventId,
  });

  final String id;
  final String name;
  final DateTime date;
  final double distanceKm;
  final int durationMinutes;
  final Province province;
  final VerificationStatus verification;
  final String source;
  final String? eventId;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'distanceKm': distanceKm,
    'durationMinutes': durationMinutes,
    'province': province.name,
    'verification': verification.name,
    'source': source,
    'eventId': eventId,
  };

  factory RaceResult.fromJson(Map<String, Object?> json) => RaceResult(
    id: json['id']! as String,
    name: json['name']! as String,
    date: DateTime.parse(json['date']! as String),
    distanceKm: (json['distanceKm']! as num).toDouble(),
    durationMinutes: json['durationMinutes']! as int,
    province: Province.values.byName(json['province']! as String),
    verification: VerificationStatus.values.byName(
      json['verification']! as String,
    ),
    source: json['source']! as String,
    eventId: json['eventId'] as String?,
  );
}

class PassportStamp {
  const PassportStamp({
    required this.id,
    required this.type,
    required this.title,
    required this.sourceResultId,
    required this.verification,
    required this.earnedAt,
    required this.criteria,
  });

  final String id;
  final StampType type;
  final String title;
  final String sourceResultId;
  final VerificationStatus verification;
  final DateTime earnedAt;
  final String criteria;

  bool get isProvisional =>
      verification != VerificationStatus.organizerVerified;
}

class Achievement {
  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.sourceResultId,
  });

  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final String sourceResultId;
}

class EventFilter {
  const EventFilter({
    this.province,
    this.distanceKm,
    this.priceStatus,
    this.fromDate,
  });

  final Province? province;
  final double? distanceKm;
  final PriceStatus? priceStatus;
  final DateTime? fromDate;
}
