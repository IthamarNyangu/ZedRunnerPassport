import '../domain/models.dart';

final demoEvents = <RaceEvent>[
  RaceEvent(
    id: 'demo-lsk-sunrise',
    name: 'Lusaka Sunrise Run',
    province: Province.lusaka,
    venue: 'Showgrounds, Lusaka',
    startAt: DateTime(2026, 10, 18, 6),
    distances: const [
      EventDistance(id: '5k', kilometres: 5),
      EventDistance(id: '10k', kilometres: 10),
    ],
    price: const EventPrice(status: PriceStatus.paid, amountZmw: 250),
    organizer: const Organizer(
      id: 'demo-move-zm',
      name: 'Move Zambia Demo Team',
    ),
    registrationDeadline: DateTime(2026, 10, 12),
    source: 'Tamanga demonstration fixture — not a live listing',
    lastUpdated: DateTime(2026, 9, 25),
    description:
        'A demonstration city run used to test discovery, saving and finish logging.',
  ),
  RaceEvent(
    id: 'demo-copperbelt-family-walk',
    name: 'Copperbelt Family Walk',
    province: Province.copperbelt,
    venue: 'Riverside, Kitwe',
    startAt: DateTime(2026, 11, 7, 7),
    distances: const [EventDistance(id: '5k', kilometres: 5)],
    price: const EventPrice(status: PriceStatus.free),
    organizer: const Organizer(
      id: 'demo-kitwe-club',
      name: 'Kitwe Community Club',
    ),
    registrationDeadline: DateTime(2026, 11, 5),
    source: 'Tamanga demonstration fixture — not a live listing',
    lastUpdated: DateTime(2026, 9, 25),
    description: 'A friendly demonstration walk where every pace belongs.',
  ),
  RaceEvent(
    id: 'demo-livingstone-half',
    name: 'Livingstone River Half',
    province: Province.southern,
    venue: 'Livingstone',
    startAt: DateTime(2026, 11, 29, 5, 30),
    distances: const [
      EventDistance(id: '10k', kilometres: 10),
      EventDistance(id: 'half', kilometres: 21.1),
    ],
    price: const EventPrice(status: PriceStatus.unknown),
    organizer: const Organizer(
      id: 'demo-south-runners',
      name: 'Southern Runners Collective',
    ),
    registrationDeadline: DateTime(2026, 11, 20),
    source: 'Tamanga demonstration fixture — not a live listing',
    lastUpdated: DateTime(2026, 9, 25),
    description:
        'A fictional pilot listing for testing the unknown-price state.',
  ),
  RaceEvent(
    id: 'demo-chipata-15',
    name: 'Chipata Hills 15',
    province: Province.eastern,
    venue: 'Chipata Central',
    startAt: DateTime(2026, 12, 12, 6),
    distances: const [EventDistance(id: '15k', kilometres: 15)],
    price: const EventPrice(status: PriceStatus.paid, amountZmw: 180),
    organizer: const Organizer(
      id: 'demo-east-pace',
      name: 'Eastern Pace Makers',
    ),
    registrationDeadline: DateTime(2026, 12, 5),
    source: 'Tamanga demonstration fixture — not a live listing',
    lastUpdated: DateTime(2026, 9, 25),
    description: 'A fictional 15 km listing created for the Tamanga pilot.',
  ),
];
