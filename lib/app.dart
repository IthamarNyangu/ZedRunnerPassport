import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'domain/models.dart';
import 'domain/passport_rules.dart';
import 'state/app_state.dart';
import 'theme/tamanga_theme.dart';

class TamangaApp extends StatelessWidget {
  const TamangaApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Tamanga',
    theme: tamangaTheme(),
    home: AnimatedBuilder(
      animation: state,
      builder: (context, _) => _AppShell(state: state),
    ),
  );
}

class _AppShell extends StatefulWidget {
  const _AppShell({required this.state});
  final AppState state;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading Tamanga'),
        ),
      );
    }
    final pages = [
      HomePage(
        state: widget.state,
        openExplore: () => setState(() => index = 1),
      ),
      ExplorePage(state: widget.state),
      PassportPage(state: widget.state),
      ProfilePage(state: widget.state),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_mosaic_outlined),
            selectedIcon: Icon(Icons.auto_awesome_mosaic),
            label: 'Passport',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.child,
    this.trailing,
  });
  final String eyebrow;
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
        sliver: SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: const TextStyle(
                        color: TamangaColours.copper,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        sliver: SliverToBoxAdapter(child: child),
      ),
    ],
  );
}

class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: TamangaColours.sun.withValues(alpha: .3),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.science_outlined, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Demo directory · These are fictional pilot listings, not live races. Confirm details before making plans.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.state, required this.openExplore});
  final AppState state;
  final VoidCallback openExplore;

  @override
  Widget build(BuildContext context) {
    final saved =
        state.events
            .where((event) => state.savedEventIds.contains(event.id))
            .toList()
          ..sort((a, b) => a.startAt.compareTo(b.startAt));
    final next = saved.isEmpty ? null : saved.first;
    final totalKm = state.results.fold<double>(
      0,
      (sum, item) => sum + item.distanceKm,
    );
    return PageFrame(
      eyebrow: 'Muli bwanji',
      title: 'Move well. Keep the story.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.loadError != null) ...[
            _MessageCard(icon: Icons.warning_amber, text: state.loadError!),
            const SizedBox(height: 12),
          ],
          _HeroPassport(
            results: state.results.length,
            kilometres: totalKm,
            stamps: state.stamps.length,
          ),
          const SizedBox(height: 22),
          _SectionHeading(
            title: 'Next on your path',
            action: next == null ? null : 'View',
          ),
          const SizedBox(height: 10),
          if (next == null)
            _EmptyCard(
              icon: Icons.bookmark_add_outlined,
              title: 'No race saved yet',
              message:
                  'Browse the demo directory and keep an event close for later.',
              actionLabel: 'Explore events',
              onPressed: openExplore,
            )
          else
            EventCard(
              event: next,
              saved: true,
              onTap: () => _openEvent(context, state, next),
            ),
          const SizedBox(height: 22),
          const _SectionHeading(title: 'A gentle recap'),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const _RoundIcon(
                    icon: Icons.directions_walk,
                    color: TamangaColours.leaf,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      state.results.isEmpty
                          ? 'Your first finish can be a walk, a run, or somewhere in between.'
                          : 'You have recorded ${state.results.length} ${state.results.length == 1 ? 'finish' : 'finishes'}. Rest belongs in the journey too.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPassport extends StatelessWidget {
  const _HeroPassport({
    required this.results,
    required this.kilometres,
    required this.stamps,
  });
  final int results;
  final double kilometres;
  final int stamps;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: TamangaColours.ink,
      borderRadius: BorderRadius.circular(30),
      gradient: const LinearGradient(
        colors: [TamangaColours.ink, Color(0xFF1C513E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.landscape_outlined, color: TamangaColours.sun),
            const SizedBox(width: 8),
            Text(
              'TAMANGA PASSPORT',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white70,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          results == 0
              ? 'Your first mark\nstarts here.'
              : '${kilometres.toStringAsFixed(1)} km\nin your story.',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _HeroMetric(value: '$results', label: 'FINISHES'),
            const SizedBox(width: 32),
            _HeroMetric(value: '$stamps', label: 'STAMPS'),
          ],
        ),
      ],
    ),
  );
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: TamangaColours.sun,
          fontWeight: FontWeight.w900,
          fontSize: 24,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    ],
  );
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, required this.state});
  final AppState state;
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Province? province;
  double? distance;
  PriceStatus? price;
  bool upcomingOnly = true;

  @override
  Widget build(BuildContext context) {
    final filtered = PassportRules.filterEvents(
      widget.state.events,
      EventFilter(
        province: province,
        distanceKm: distance,
        priceStatus: price,
        fromDate: upcomingOnly ? DateTime(2026, 9, 25) : null,
      ),
    );
    return PageFrame(
      eyebrow: 'Across Zambia',
      title: 'Find your next start line',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DemoBanner(),
          const SizedBox(height: 16),
          DropdownButtonFormField<Province?>(
            initialValue: province,
            decoration: const InputDecoration(
              labelText: 'Province',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All provinces')),
              ...Province.values.map(
                (item) =>
                    DropdownMenuItem(value: item, child: Text(item.label)),
              ),
            ],
            onChanged: (value) => setState(() => province = value),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Upcoming'),
                  selected: upcomingOnly,
                  onSelected: (value) => setState(() => upcomingOnly = value),
                ),
                const SizedBox(width: 8),
                ...[5.0, 10.0, 15.0, 21.1, 42.2].map(
                  (value) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        '${value % 1 == 0 ? value.toInt() : value} km',
                      ),
                      selected: distance == value,
                      onSelected: (selected) =>
                          setState(() => distance = selected ? value : null),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<PriceStatus?>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: null, label: Text('Any')),
              ButtonSegment(value: PriceStatus.free, label: Text('Free')),
              ButtonSegment(value: PriceStatus.paid, label: Text('Paid')),
              ButtonSegment(value: PriceStatus.unknown, label: Text('Unknown')),
            ],
            selected: {price},
            onSelectionChanged: (selection) =>
                setState(() => price = selection.first),
          ),
          const SizedBox(height: 20),
          Text(
            '${filtered.length} demo ${filtered.length == 1 ? 'event' : 'events'}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            const _EmptyCard(
              icon: Icons.search_off,
              title: 'No demo events match',
              message: 'Try clearing a distance, price, or province filter.',
            )
          else
            ...filtered.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EventCard(
                  event: event,
                  saved: widget.state.savedEventIds.contains(event.id),
                  onTap: () => _openEvent(context, widget.state, event),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.saved,
    required this.onTap,
  });
  final RaceEvent event;
  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateTile(date: event.startAt),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (saved)
                        const Icon(
                          Icons.bookmark,
                          color: TamangaColours.copper,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${event.province.label} · ${event.venue}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...event.distances.map(
                        (item) => _Pill(item.displayLabel),
                      ),
                      _Pill(
                        event.price.label,
                        accent: event.price.status == PriceStatus.free,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.state, required this.event});
  final AppState state;
  final RaceEvent event;

  @override
  Widget build(BuildContext context) {
    final saved = state.savedEventIds.contains(event.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TamangaColours.sand,
        title: const Text('Event details'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
        children: [
          const DemoBanner(),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: TamangaColours.ink,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.province.label.toUpperCase(),
                  style: const TextStyle(
                    color: TamangaColours.sun,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.name,
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  DateFormat('EEEE, d MMMM y · HH:mm').format(event.startAt),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    icon: Icons.place_outlined,
                    title: event.venue,
                    subtitle: event.province.label,
                  ),
                  _DetailRow(
                    icon: Icons.route_outlined,
                    title: event.distances
                        .map((item) => item.displayLabel)
                        .join(' · '),
                    subtitle: 'Available distances',
                  ),
                  _DetailRow(
                    icon: Icons.payments_outlined,
                    title: event.price.label,
                    subtitle: event.price.status == PriceStatus.unknown
                        ? 'Do not assume this event is free'
                        : 'Entry status',
                  ),
                  _DetailRow(
                    icon: Icons.groups_outlined,
                    title: event.organizer.name,
                    subtitle: event.organizer.isVerified
                        ? 'Verified organizer'
                        : 'Organizer not yet verified by Tamanga',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'About this demo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(event.description),
          const SizedBox(height: 18),
          _MessageCard(
            icon: Icons.info_outline,
            text:
                '${event.source}. Updated ${DateFormat('d MMM y').format(event.lastUpdated)}.',
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () async {
              await state.toggleSaved(event.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      saved
                          ? 'Removed from saved events'
                          : 'Saved on this device',
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              saved
                  ? Icons.bookmark_remove_outlined
                  : Icons.bookmark_add_outlined,
            ),
            label: Text(saved ? 'Remove saved event' : 'Save event'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => showAddFinish(context, state, event: event),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Log a finish for this event'),
          ),
        ],
      ),
    );
  }
}

class PassportPage extends StatelessWidget {
  const PassportPage({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => PageFrame(
    eyebrow: 'Collected honestly',
    title: 'Your running passport',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MessageCard(
          icon: Icons.verified_user_outlined,
          text:
              'A self-reported finish earns a provisional stamp. Only organizer confirmation can make it verified.',
        ),
        const SizedBox(height: 22),
        _SectionHeading(
          title: 'Passport stamps',
          action: '${state.stamps.length} earned',
        ),
        const SizedBox(height: 10),
        if (state.stamps.isEmpty)
          const _EmptyCard(
            icon: Icons.auto_awesome_mosaic_outlined,
            title: 'A passport ready for stories',
            message:
                'Log a completed race to create your first transparent, provisional stamp.',
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .82,
            ),
            itemCount: state.stamps.length,
            itemBuilder: (context, index) =>
                StampCard(stamp: state.stamps[index]),
          ),
        const SizedBox(height: 24),
        _SectionHeading(
          title: 'Distance milestones',
          action: '${state.achievements.length} unlocked',
        ),
        const SizedBox(height: 10),
        if (state.achievements.isEmpty)
          const _EmptyCard(
            icon: Icons.emoji_events_outlined,
            title: 'Milestones will appear here',
            message:
                '5, 10, 15, 21.1 and 42.2 km use a small real-world distance tolerance.',
          )
        else
          ...state.achievements.map(
            (achievement) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AchievementTile(achievement: achievement),
            ),
          ),
      ],
    ),
  );
}

class StampCard extends StatelessWidget {
  const StampCard({super.key, required this.stamp});
  final PassportStamp stamp;
  @override
  Widget build(BuildContext context) => Card(
    color: stamp.isProvisional ? const Color(0xFFFFF5DF) : TamangaColours.mist,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              stamp.type == StampType.province
                  ? Icons.landscape_outlined
                  : Icons.directions_run,
              color: TamangaColours.copper,
              size: 32,
            ),
          ),
          const Spacer(),
          Text(
            stamp.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _Pill(
            stamp.isProvisional ? 'PROVISIONAL' : 'VERIFIED',
            accent: !stamp.isProvisional,
          ),
          const SizedBox(height: 8),
          Text(
            stamp.criteria,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final sortedResults = [...state.results]
      ..sort((a, b) => b.date.compareTo(a.date));
    return PageFrame(
      eyebrow: 'Private by default',
      title: 'My movement story',
      trailing: IconButton.filled(
        onPressed: () => showAddFinish(context, state),
        icon: const Icon(Icons.add),
        tooltip: 'Add a finish',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: TamangaColours.mist,
                        child: Icon(
                          Icons.person_outline,
                          color: TamangaColours.forest,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tamanga runner',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Local-only pilot profile',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: state.includeNameOnShare,
                    title: const Text('Show my name on share cards'),
                    subtitle: const Text(
                      'Off by default; event date and location stay hidden.',
                    ),
                    onChanged: state.setIncludeNameOnShare,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _SectionHeading(
            title: 'Race history',
            action: '${sortedResults.length} total',
          ),
          const SizedBox(height: 10),
          if (sortedResults.isEmpty)
            _EmptyCard(
              icon: Icons.history,
              title: 'No finishes recorded',
              message:
                  'Add a past race or walk. It will be clearly marked self-reported.',
              actionLabel: 'Add first finish',
              onPressed: () => showAddFinish(context, state),
            )
          else
            ...sortedResults.map(
              (result) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ResultCard(state: state, result: result),
              ),
            ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.state, required this.result});
  final AppState state;
  final RaceResult result;
  @override
  Widget build(BuildContext context) {
    final category = PassportRules.distanceCategory(result.distanceKm);
    final count = category == null ? 0 : state.repeatCounts[category] ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => showShareCard(context, state, result),
                  icon: const Icon(Icons.ios_share_outlined),
                  tooltip: 'Open private share card',
                ),
              ],
            ),
            Text(
              '${DateFormat('d MMM y').format(result.date)} · ${result.province.label}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ResultMetric(
                    value:
                        '${result.distanceKm.toStringAsFixed(result.distanceKm % 1 == 0 ? 0 : 1)} km',
                    label: 'DISTANCE',
                  ),
                ),
                Expanded(
                  child: _ResultMetric(
                    value: _formatDuration(result.durationMinutes),
                    label: 'TIME',
                  ),
                ),
                if (count > 0)
                  Expanded(
                    child: _ResultMetric(
                      value: '$count×',
                      label: category == null
                          ? 'REPEATS'
                          : '${category.toString()} KM',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _Pill(result.verification.label.toUpperCase()),
          ],
        ),
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
      ),
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black54,
          fontWeight: FontWeight.w700,
          letterSpacing: .7,
        ),
      ),
    ],
  );
}

Future<void> showAddFinish(
  BuildContext context,
  AppState state, {
  RaceEvent? event,
}) async {
  final name = TextEditingController(text: event?.name ?? '');
  final distance = TextEditingController(
    text: event?.distances.first.kilometres.toString() ?? '',
  );
  final minutes = TextEditingController();
  Province province = event?.province ?? Province.lusaka;
  final formKey = GlobalKey<FormState>();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log a completed race',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manual entries are saved on this device and always labeled self-reported.',
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Event or activity name',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a name'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: distance,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Distance (km)',
                        ),
                        validator: _positiveNumberValidator,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: minutes,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Time (minutes)',
                        ),
                        validator: _positiveNumberValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Province>(
                  initialValue: province,
                  decoration: const InputDecoration(labelText: 'Province'),
                  items: Province.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setSheetState(() => province = value ?? province),
                ),
                const SizedBox(height: 18),
                const _MessageCard(
                  icon: Icons.fact_check_outlined,
                  text: 'Verification: Self-reported · Source: Manual entry',
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final now = DateTime.now();
                      await state.addResult(
                        RaceResult(
                          id: 'manual-${now.microsecondsSinceEpoch}',
                          name: name.text.trim(),
                          date: now,
                          distanceKm: double.parse(distance.text),
                          durationMinutes: double.parse(minutes.text).round(),
                          province: province,
                          verification: VerificationStatus.selfReported,
                          source: 'Manual entry on this device',
                          eventId: event?.id,
                        ),
                      );
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                    },
                    child: const Text('Save self-reported finish'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  name.dispose();
  distance.dispose();
  minutes.dispose();
}

Future<void> showShareCard(
  BuildContext context,
  AppState state,
  RaceResult result,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Private share card',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          const Text(
            'Name is optional. Exact date, province, route and time are hidden from the shared copy.',
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [TamangaColours.ink, TamangaColours.forest],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.landscape_outlined, color: TamangaColours.sun),
                    SizedBox(width: 8),
                    Text(
                      'TAMANGA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (state.includeNameOnShare)
                  const Text(
                    'TAMANGA RUNNER',
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                Text(
                  '${result.distanceKm.toStringAsFixed(result.distanceKm % 1 == 0 ? 0 : 1)} km',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 52,
                  ),
                ),
                Text(
                  'FINISH RECORDED',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: TamangaColours.sun,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Every effort counts.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const _Pill('SELF-REPORTED'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final identity = state.includeNameOnShare
                    ? 'Tamanga runner · '
                    : '';
                await Clipboard.setData(
                  ClipboardData(
                    text:
                        '$identity${result.distanceKm.toStringAsFixed(1)} km finish recorded on Tamanga. Self-reported. Every effort counts.',
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy-safe share text copied'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy_all_outlined),
              label: const Text('Copy privacy-safe share text'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});
  final Achievement achievement;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: const _RoundIcon(
        icon: Icons.emoji_events_outlined,
        color: TamangaColours.sun,
      ),
      title: Text(
        achievement.title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(achievement.description),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: TamangaColours.forest),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.date});
  final DateTime date;
  @override
  Widget build(BuildContext context) => Container(
    width: 54,
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: TamangaColours.mist,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Text(
          DateFormat('MMM').format(date).toUpperCase(),
          style: const TextStyle(
            color: TamangaColours.forest,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        Text(
          '${date.day}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.action});
  final String title;
  final String? action;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      if (action != null)
        Text(
          action!,
          style: const TextStyle(
            color: TamangaColours.forest,
            fontWeight: FontWeight.w700,
          ),
        ),
    ],
  );
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onPressed,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _RoundIcon(icon: icon, color: TamangaColours.leaf),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 14),
            TextButton(onPressed: onPressed, child: Text(actionLabel!)),
          ],
        ],
      ),
    ),
  );
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: TamangaColours.mist,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: TamangaColours.forest),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .22),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: TamangaColours.ink),
  );
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, {this.accent = false});
  final String text;
  final bool accent;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: accent
          ? TamangaColours.leaf.withValues(alpha: .22)
          : Colors.black.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: .4,
      ),
    ),
  );
}

void _openEvent(BuildContext context, AppState state, RaceEvent event) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnimatedBuilder(
          animation: state,
          builder: (context, _) => EventDetailPage(state: state, event: event),
        ),
      ),
    );

String? _positiveNumberValidator(String? value) {
  final number = double.tryParse(value ?? '');
  return number == null || number <= 0 ? 'Enter a number above 0' : null;
}

String _formatDuration(int minutes) =>
    minutes >= 60 ? '${minutes ~/ 60}h ${minutes % 60}m' : '${minutes}m';
