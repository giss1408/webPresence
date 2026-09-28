import 'package:flutter/material.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/showcase/demo_kit.dart';
import 'package:provider/provider.dart';

/// The products shown in the live phone demo.
enum DemoApp { akwaba, djassa, djassaUser, immoizi }

/// One step of a demo script: the screen shown, what the caption under the
/// phone says, and (optionally) the target the scripted finger taps at the
/// end of the step and a push notification shown during it.
class DemoStep {
  const DemoStep({
    required this.screen,
    required this.caption,
    this.tap,
    this.notice,
    this.back = false,
  });

  /// Steps with the same screen id update the page in place; a new id
  /// navigates (with the platform's page transition).
  final String screen;
  final String caption;
  final String? tap;

  /// Translation key of a push notification's body.
  final String? notice;

  /// Arrive with the "back" transition (returning to an earlier screen).
  final bool back;
}

class DemoAppSpec {
  const DemoAppSpec({
    required this.name,
    this.tag,
    required this.seed,
    required this.icon,
    required this.steps,
    required this.build,
  });

  final String name;

  /// Translation key of a suffix telling apart two apps of one product
  /// ("Djassa · Customers").
  final String? tag;
  final Color seed;
  final IconData icon;
  final List<DemoStep> steps;

  /// Builds the screen for step [step].
  final Widget Function(int step) build;
}

final Map<DemoApp, DemoAppSpec> demoApps = {
  DemoApp.akwaba: DemoAppSpec(
    name: 'Akwaba Ivoire',
    seed: const Color(0xFFF77F00),
    icon: Icons.travel_explore,
    steps: const [
      DemoStep(screen: 'home', caption: 'demo.ak.step1', tap: 'ak.card'),
      DemoStep(screen: 'detail', caption: 'demo.ak.step2', tap: 'ak.book'),
      DemoStep(screen: 'booking', caption: 'demo.ak.step3', tap: 'ak.pay'),
      DemoStep(
          screen: 'done',
          caption: 'demo.ak.step4',
          tap: 'ak.done',
          notice: 'demo.ak.notice'),
    ],
    build: (step) => switch (step) {
      0 => const _AkwabaHome(),
      1 => const _AkwabaDetail(),
      2 => const _AkwabaBooking(),
      _ => const _AkwabaConfirmed(),
    },
  ),
  DemoApp.djassa: DemoAppSpec(
    name: 'Djassa',
    tag: 'demo.dj.tag',
    seed: const Color(0xFFD1571E),
    icon: Icons.storefront,
    steps: const [
      DemoStep(screen: 'home', caption: 'demo.dj.step1', tap: 'dj.new'),
      DemoStep(screen: 'sale', caption: 'demo.dj.step2', tap: 'dj.save'),
      DemoStep(screen: 'home', caption: 'demo.dj.step3'),
      DemoStep(
          screen: 'home', caption: 'demo.dj.step4', notice: 'demo.dj.notice'),
    ],
    build: (step) => switch (step) {
      0 => const _DjassaHome(stage: _SaleStage.offline),
      1 => const _DjassaNewSale(),
      2 => const _DjassaHome(stage: _SaleStage.saved),
      _ => const _DjassaHome(stage: _SaleStage.synced),
    },
  ),
  DemoApp.djassaUser: DemoAppSpec(
    name: 'Djassa',
    tag: 'demo.dju.tag',
    seed: const Color(0xFFC94A22),
    icon: Icons.local_pharmacy,
    steps: const [
      DemoStep(screen: 'home', caption: 'demo.dju.step1', tap: 'dju.duty'),
      DemoStep(screen: 'duty', caption: 'demo.dju.step2', tap: 'dju.back'),
      DemoStep(
          screen: 'home',
          caption: 'demo.dju.step3',
          tap: 'dju.maquis',
          back: true),
      DemoStep(screen: 'venue', caption: 'demo.dju.step4', tap: 'dju.pay'),
      DemoStep(
          screen: 'paid',
          caption: 'demo.dju.step5',
          tap: 'dju.done',
          notice: 'demo.dju.notice'),
    ],
    build: (step) => switch (step) {
      0 => const _DjassaUserHome(target: 'dju.duty'),
      1 => const _OnDutyPharmacies(),
      2 => const _DjassaUserHome(target: 'dju.maquis'),
      3 => const _MaquisVenue(),
      _ => const _DjassaUserPaid(),
    },
  ),
  DemoApp.immoizi: DemoAppSpec(
    name: 'Immoizi',
    seed: const Color(0xFF6272A4),
    icon: Icons.apartment,
    steps: const [
      DemoStep(screen: 'home', caption: 'demo.im.step1', tap: 'im.property'),
      DemoStep(screen: 'units', caption: 'demo.im.step2', tap: 'im.remind'),
      DemoStep(screen: 'units', caption: 'demo.im.step3'),
      DemoStep(
          screen: 'units',
          caption: 'demo.im.step4',
          tap: 'im.back',
          notice: 'demo.im.notice'),
    ],
    build: (step) => switch (step) {
      0 => const _ImmoHome(),
      1 => const _ImmoUnits(stage: _RentStage.late),
      2 => const _ImmoUnits(stage: _RentStage.reminded),
      _ => const _ImmoUnits(stage: _RentStage.paid),
    },
  ),
};

// ─── Shared bits ──────────────────────────────────────────────────────────────

const _ivoryGreen = Color(0xFF009E60);

extension on BuildContext {
  String tr(String key) => watch<LocaleProvider>().tr(key);
  String money(int amount) => fcfa(amount, watch<LocaleProvider>().locale);
  ColorScheme get scheme => Theme.of(this).colorScheme;
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.color, {super.key, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo(this.asset,
      {required this.width, required this.height, this.radius = 12});

  final String asset;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child:
          Image.asset(asset, width: width, height: height, fit: BoxFit.cover),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.scheme.onSurfaceVariant)),
    );
  }
}

// ─── Akwaba Ivoire (tourism) ──────────────────────────────────────────────────

const _beach = 'assets/images/highlights/highlight_beach.jpg';

class _AkwabaHome extends StatelessWidget {
  const _AkwabaHome();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);
    Widget card(String asset, String title, String place, String rating,
        {String? target}) {
      final content = SizedBox(
        width: 168,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Photo(asset, width: 168, height: 150, radius: ios ? 14 : 20),
            const SizedBox(height: 8),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface)),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                Text(' $rating · ',
                    style: TextStyle(fontSize: 12, color: scheme.onSurface)),
                Flexible(
                  child: Text(place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                ),
              ],
            ),
          ],
        ),
      );
      return target == null ? content : DemoTarget(id: target, child: content);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('demo.ak.hello'),
                        style: TextStyle(
                            fontSize: 13, color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 2),
                    Text(context.tr('demo.ak.where'),
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 22,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: scheme.primaryContainer,
                child: Text('A',
                    style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: ios
                  ? scheme.surfaceContainerHigh
                  : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(ios ? 11 : 21),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: scheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(context.tr('demo.ak.search'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14, color: scheme.onSurfaceVariant)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              for (final (i, (icon, key)) in const [
                (Icons.beach_access, 'demo.ak.cat_beach'),
                (Icons.forest, 'demo.ak.cat_nature'),
                (Icons.museum, 'demo.ak.cat_culture'),
              ].indexed) ...[
                if (i > 0) const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: i == 0 ? scheme.primary : null,
                      border: i == 0
                          ? null
                          : Border.all(color: scheme.outlineVariant),
                      borderRadius: BorderRadius.circular(ios ? 18 : 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon,
                            size: 14,
                            color: i == 0
                                ? scheme.onPrimary
                                : scheme.onSurfaceVariant),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(context.tr(key),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: i == 0
                                      ? scheme.onPrimary
                                      : scheme.onSurface)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
          child: Text(context.tr('demo.ak.popular'),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface)),
        ),
        // A peek at the next card, like a horizontal list (no Scrollable, so
        // page scrolling and tests are unaffected).
        SizedBox(
          height: 206,
          child: ClipRect(
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    card(_beach, 'Assinie-Mafia', 'Sud-Comoé', '4.8',
                        target: 'ak.card'),
                    const SizedBox(width: 12),
                    card('assets/images/highlights/highlight_wildlife.jpg',
                        'Parc de la Comoé', 'Bouna', '4.7'),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        DemoNavBar(items: [
          (Icons.explore, context.tr('demo.ak.explore')),
          (Icons.map_outlined, context.tr('demo.ak.map')),
          (Icons.luggage_outlined, context.tr('demo.ak.trips')),
          (Icons.person_outline, context.tr('demo.ak.profile')),
        ]),
      ],
    );
  }
}

class _AkwabaDetail extends StatelessWidget {
  const _AkwabaDetail();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.asset(_beach,
                height: 230, width: double.infinity, fit: BoxFit.cover),
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final icon in [
                    ios ? Icons.arrow_back_ios_new : Icons.arrow_back,
                    Icons.favorite_border,
                  ])
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: Icon(icon, size: 18, color: Colors.black87),
                    ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assinie-Mafia',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.place_outlined,
                      size: 15, color: scheme.onSurfaceVariant),
                  Text(' Sud-Comoé  ',
                      style: TextStyle(
                          fontSize: 13, color: scheme.onSurfaceVariant)),
                  const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                  Text(' 4.8',
                      style: TextStyle(fontSize: 13, color: scheme.onSurface)),
                ],
              ),
              const SizedBox(height: 12),
              Text(context.tr('demo.ak.assinie_desc'),
                  style: TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: scheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final (icon, label) in [
                    (Icons.beach_access, context.tr('demo.ak.cat_beach')),
                    (Icons.kayaking, context.tr('demo.ak.cat_nature')),
                    (Icons.chat_outlined, 'WhatsApp'),
                  ])
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              borderRadius:
                                  BorderRadius.circular(ios ? 12 : 22),
                            ),
                            child: Icon(icon,
                                size: 20, color: scheme.onPrimaryContainer),
                          ),
                          const SizedBox(height: 6),
                          Text(label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('demo.ak.from'),
                        style: TextStyle(
                            fontSize: 11, color: scheme.onSurfaceVariant)),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '${context.money(45000)} ${context.tr('demo.ak.night')}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: DemoButton(
                    label: context.tr('demo.ak.book'), target: 'ak.book'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AkwabaBooking extends StatelessWidget {
  const _AkwabaBooking();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);
    final days = [
      ('demo.ak.thu', 11),
      ('demo.ak.fri', 12),
      ('demo.ak.sat', 13),
      ('demo.ak.sun', 14),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoAppBar(title: context.tr('demo.ak.booking'), back: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DemoCard(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const _Photo(_beach, width: 52, height: 52, radius: 10),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assinie-Mafia',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSurface)),
                          Text(context.tr('demo.ak.nights'),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _Label(context.tr('demo.ak.dates')),
              Row(
                children: [
                  for (final (i, (day, date)) in days.indexed) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: i == 1 || i == 3
                              ? scheme.primary
                              : i == 2
                                  ? scheme.primaryContainer
                                  : null,
                          border: i == 0
                              ? Border.all(color: scheme.outlineVariant)
                              : null,
                          borderRadius: BorderRadius.circular(ios ? 12 : 20),
                        ),
                        child: Column(
                          children: [
                            Text(context.tr(day),
                                style: TextStyle(
                                    fontSize: 11,
                                    color: i == 1 || i == 3
                                        ? scheme.onPrimary
                                        : scheme.onSurfaceVariant)),
                            Text('$date',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: i == 1 || i == 3
                                        ? scheme.onPrimary
                                        : scheme.onSurface)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(context.tr('demo.ak.travellers'),
                        style:
                            TextStyle(fontSize: 14, color: scheme.onSurface)),
                  ),
                  for (final (i, icon)
                      in [Icons.remove, Icons.add].indexed) ...[
                    if (i == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('2',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface)),
                      ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Icon(icon, size: 16, color: scheme.primary),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(context.tr('demo.ak.guide'),
                        style:
                            TextStyle(fontSize: 14, color: scheme.onSurface)),
                  ),
                  // Cupertino switch on iOS, Material 3 switch on Android.
                  Switch.adaptive(value: true, onChanged: (_) {}),
                ],
              ),
              Divider(height: 24, color: scheme.outlineVariant),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        '${context.tr('demo.ak.nights')} × ${context.money(45000)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13, color: scheme.onSurfaceVariant)),
                  ),
                  Text(context.money(90000),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface)),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: DemoButton(
            label: '${context.tr('demo.ak.pay')} ${context.money(90000)}',
            target: 'ak.pay',
            icon: Icons.lock_outline,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(context.tr('demo.ak.secure'),
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ),
        ),
      ],
    );
  }
}

class _AkwabaConfirmed extends StatelessWidget {
  const _AkwabaConfirmed();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Column(
        children: [
          const Spacer(flex: 3),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, t, child) =>
                Transform.scale(scale: t, child: child),
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                  color: _ivoryGreen, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  size: 52, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(context.tr('demo.ak.confirmed'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface)),
          const SizedBox(height: 6),
          Text('${context.tr('demo.ak.ref')} AKW-2841',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 22),
          DemoCard(
            child: Row(
              children: [
                const _Photo(_beach, width: 48, height: 48, radius: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assinie-Mafia',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface)),
                      Text(
                          '12 – 14 ${context.tr('demo.ak.month')} · '
                          '${context.tr('demo.ak.travellers')}',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 4),
          DemoButton(label: context.tr('demo.ak.done'), target: 'ak.done'),
        ],
      ),
    );
  }
}

// ─── Djassa (merchant sales, offline-first) ───────────────────────────────────

enum _SaleStage { offline, saved, synced }

class _DjassaHome extends StatelessWidget {
  const _DjassaHome({required this.stage});

  final _SaleStage stage;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);
    final online = stage == _SaleStage.synced;
    final sales = [
      if (stage != _SaleStage.offline) ('sync.p4', '10:51', 2500),
      ('sync.p1', '10:42', 4500),
      ('sync.p2', '10:15', 1800),
      ('sync.p3', '09:58', 900),
    ];
    final total = stage == _SaleStage.offline ? 48500 : 51000;
    const bars = [0.35, 0.55, 0.4, 0.7, 0.5, 0.85, 1.0];

    final newSale = ios
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: DemoButton(
                label: context.tr('demo.dj.new'),
                target: 'dj.new',
                icon: Icons.add),
          )
        : Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: DemoTarget(
                id: 'dj.new',
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 8,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: scheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Text(context.tr('demo.dj.new'),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: scheme.onPrimaryContainer)),
                    ],
                  ),
                ),
              ),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoAppBar(
          title: context.tr('demo.dj.shop'),
          large: true,
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _Badge(
              key: ValueKey(online),
              context.tr(online ? 'demo.dj.online' : 'demo.dj.offline'),
              online ? _ivoryGreen : scheme.onSurfaceVariant,
              icon: online ? Icons.cloud_done_outlined : Icons.cloud_off,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scheme.primary,
                  Color.lerp(scheme.primary, Colors.black, 0.25)!
                ],
              ),
              borderRadius: BorderRadius.circular(ios ? 14 : 20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr('demo.dj.today'),
                          style: TextStyle(
                              fontSize: 12,
                              color: scheme.onPrimary.withOpacity(0.85))),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: total.toDouble()),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, value, _) => Text(
                              context.money(value.round()),
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onPrimary)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(context.tr('demo.dj.vs'),
                          style: TextStyle(
                              fontSize: 11,
                              color: scheme.onPrimary.withOpacity(0.85))),
                    ],
                  ),
                ),
                for (final bar in bars)
                  Container(
                    width: 7,
                    height: 44 * bar,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: scheme.onPrimary.withOpacity(bar == 1 ? 1 : 0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
          child: _Label(context.tr('demo.dj.latest')),
        ),
        for (final (i, (product, time, amount)) in sales.indexed)
          _SaleRow(
            // New rows slide in; keyed so existing rows keep their state.
            key: ValueKey(product),
            product: context.tr(product),
            time: time,
            amount: context.money(amount),
            synced: online,
            highlight: i == 0 && stage == _SaleStage.saved,
          ),
        const Spacer(),
        if (stage == _SaleStage.saved)
          DemoToast(
              icon: Icons.phone_android, text: context.tr('demo.dj.saved'))
        else
          newSale,
      ],
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({
    super.key,
    required this.product,
    required this.time,
    required this.amount,
    required this.synced,
    required this.highlight,
  });

  final String product;
  final String time;
  final String amount;
  final bool synced;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child:
            Transform.translate(offset: Offset(-20 * (1 - t), 0), child: child),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: highlight ? scheme.primaryContainer.withOpacity(0.6) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.surfaceContainerHighest,
              child: Icon(Icons.shopping_basket_outlined,
                  size: 16, color: scheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface)),
                  Text(time,
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Text(amount,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface)),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                synced ? Icons.cloud_done : Icons.schedule,
                key: ValueKey(synced),
                size: 16,
                color: synced ? _ivoryGreen : Colors.orange.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DjassaNewSale extends StatelessWidget {
  const _DjassaNewSale();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);
    const typed = '2500';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoAppBar(title: context.tr('demo.dj.new'), back: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Label(context.tr('demo.dj.product')),
              DemoCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.shopping_basket_outlined,
                        size: 18, color: scheme.primary),
                    const SizedBox(width: 10),
                    Text(context.tr('sync.p4'),
                        style:
                            TextStyle(fontSize: 14, color: scheme.onSurface)),
                  ],
                ),
              ),
              // The amount is "typed" digit by digit.
              SizedBox(
                height: 76,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: typed.length.toDouble()),
                    duration: const Duration(milliseconds: 1100),
                    builder: (context, t, _) {
                      final digits = typed.substring(0, t.floor());
                      return Text(
                        context.money(int.tryParse(digits) ?? 0),
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface),
                      );
                    },
                  ),
                ),
              ),
              _Label(context.tr('demo.dj.method')),
              Row(
                children: [
                  for (final (i, label) in [
                    context.tr('demo.dj.cash'),
                    'Orange Money',
                    'Wave',
                  ].indexed) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Flexible(
                      // "Orange Money" gets the room it needs.
                      flex: i == 1 ? 3 : 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 7),
                        decoration: BoxDecoration(
                          color: i == 0 ? scheme.secondaryContainer : null,
                          border: Border.all(
                              color: i == 0
                                  ? scheme.secondaryContainer
                                  : scheme.outlineVariant),
                          borderRadius: BorderRadius.circular(ios ? 16 : 8),
                        ),
                        child: Text(label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: i == 0
                                    ? scheme.onSecondaryContainer
                                    : scheme.onSurface)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        // Numeric keypad
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              for (final row in const [
                ['1', '2', '3'],
                ['4', '5', '6'],
                ['7', '8', '9'],
                ['000', '0', '⌫'],
              ])
                Row(
                  children: [
                    for (final key in row)
                      Expanded(
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(ios ? 10 : 21),
                          ),
                          child: key == '⌫'
                              ? Icon(Icons.backspace_outlined,
                                  size: 18, color: scheme.onSurface)
                              : Text(key,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: scheme.onSurface)),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: DemoButton(
              label: context.tr('demo.dj.save'),
              target: 'dj.save',
              icon: Icons.check),
        ),
      ],
    );
  }
}

// ─── Immoizi (property management) ────────────────────────────────────────────

enum _RentStage { late, reminded, paid }

class _ImmoHome extends StatelessWidget {
  const _ImmoHome();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    Widget property(
        String asset, String name, String units, String badge, Color badgeColor,
        {String? target, Alignment alignment = Alignment.center}) {
      final card = DemoCard(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(asset,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  alignment: alignment),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface)),
                  const SizedBox(height: 2),
                  Text(units,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  _Badge(badge, badgeColor),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
          ],
        ),
      );
      return target == null ? card : DemoTarget(id: target, child: card);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoAppBar(
          title: context.tr('demo.im.properties'),
          large: true,
          trailing: Icon(Icons.notifications_none, color: scheme.onSurface),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(isIos(context) ? 14 : 20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('demo.im.collected'),
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.onPrimary.withOpacity(0.85))),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(context.money(1250000),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: scheme.onPrimary)),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 0.89),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 7,
                          color: scheme.onPrimary,
                          backgroundColor: scheme.onPrimary.withOpacity(0.25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('89 % · ${context.money(1400000)}',
                        style: TextStyle(
                            fontSize: 11,
                            color: scheme.onPrimary.withOpacity(0.85))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              property(
                  'assets/images/abidjan-web.jpg',
                  'Résidence Cocody',
                  context.tr('demo.im.units6'),
                  context.tr('demo.im.one_late'),
                  Colors.red.shade600,
                  target: 'im.property'),
              const SizedBox(height: 10),
              property(
                  'assets/images/abidjan-web.jpg',
                  'Villa Riviera',
                  context.tr('demo.im.units1'),
                  context.tr('demo.im.paid'),
                  _ivoryGreen,
                  alignment: Alignment.centerRight),
            ],
          ),
        ),
        const Spacer(),
        DemoNavBar(items: [
          (Icons.home_work_outlined, context.tr('demo.im.home')),
          (Icons.people_outline, context.tr('demo.im.tenants')),
          (Icons.build_outlined, context.tr('demo.im.requests')),
        ]),
      ],
    );
  }
}

class _ImmoUnits extends StatelessWidget {
  const _ImmoUnits({required this.stage});

  final _RentStage stage;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final paid = (context.tr('demo.im.paid'), _ivoryGreen);
    final units = [
      ('A1', 'M. Kouassi', paid),
      ('A2', 'M. Diallo', null),
      ('A3', 'Mme Traoré', paid),
      ('B1', 'M. Koné', paid),
      ('B2', 'Mme Yao', paid),
      ('B3', '—', (context.tr('demo.im.vacant'), scheme.onSurfaceVariant)),
    ];

    Widget diallo() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: switch (stage) {
          _RentStage.late => DemoTarget(
              key: const ValueKey('late'),
              id: 'im.remind',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(isIos(context) ? 8 : 16),
                ),
                child: Text(context.tr('demo.im.remind'),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: scheme.onPrimary)),
              ),
            ),
          _RentStage.reminded => _Badge(
              key: const ValueKey('reminded'),
              context.tr('demo.im.reminded_badge'),
              Colors.orange.shade700,
              icon: Icons.schedule_send),
          _RentStage.paid => _Badge(
              key: const ValueKey('paid'), paid.$1, paid.$2, icon: Icons.check),
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DemoAppBar(
            title: 'Résidence Cocody', back: true, backTarget: 'im.back'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Label(context.tr('demo.im.units_title')),
              DemoCard(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    for (final (i, (unit, tenant, status))
                        in units.indexed) ...[
                      if (i > 0)
                        Divider(height: 1, color: scheme.outlineVariant),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: scheme.secondaryContainer,
                              child: Text(unit,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: scheme.onSecondaryContainer)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tenant,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: scheme.onSurface)),
                                  if (status == null &&
                                      stage != _RentStage.paid)
                                    Text(context.tr('demo.im.late'),
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.red.shade600))
                                  else if (unit != 'B3')
                                    Text(context.money(150000),
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: scheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            if (status == null)
                              diallo()
                            else
                              _Badge(status.$1, status.$2),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (stage == _RentStage.reminded)
          DemoToast(
              icon: Icons.chat_outlined, text: context.tr('demo.im.reminded')),
      ],
    );
  }
}

// ─── Djassa for customers (maquis, on-duty pharmacies, pay) ──────────────────

/// Pharmacy cross colour of the Djassa apps; distinct from the brand.
const _pharmacy = Color(0xFF12855A);

/// Djassa's gradient header: orange on most screens, green for pharmacies.
class _GradientHeader extends StatelessWidget {
  const _GradientHeader({required this.colors, required this.child});

  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: child,
    );
  }
}

/// Djassa's tab bar: four tabs around a raised "Pay" scan button.
class _DjassaTabBar extends StatelessWidget {
  const _DjassaTabBar();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    Widget tab(IconData icon, String label, {bool selected = false}) {
      final color = selected ? scheme.primary : scheme.onSurfaceVariant;
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: color)),
          ],
        ),
      );
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tab(Icons.home_rounded, context.tr('demo.im.home'), selected: true),
          tab(Icons.explore_outlined, context.tr('demo.ak.explore')),
          SizedBox(
            width: 64,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -18,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE65E32), Color(0xFF9E3517)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.surface, width: 3),
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded,
                        color: Colors.white, size: 24),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  child: Text(context.tr('demo.dju.pay'),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: scheme.primary)),
                ),
              ],
            ),
          ),
          tab(Icons.local_offer_outlined, context.tr('demo.dju.deals')),
          tab(Icons.stars_outlined, context.tr('demo.dju.loyalty')),
        ],
      ),
    );
  }
}

class _DjassaUserHome extends StatelessWidget {
  const _DjassaUserHome({required this.target});

  /// Which shortcut the script taps next: the on-duty tile or a maquis.
  final String target;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);

    Widget shortcut(IconData icon, String label, Color color,
        {bool live = false, String? id}) {
      final tile = Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.13),
          borderRadius: BorderRadius.circular(ios ? 14 : 18),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 24, color: color),
                if (live)
                  const Positioned(right: -6, top: -3, child: _PulseDot()),
              ],
            ),
            const SizedBox(height: 6),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface)),
          ],
        ),
      );
      return Expanded(
          child: id == target ? DemoTarget(id: id!, child: tile) : tile);
    }

    Widget maquis(IconData icon, Color color, String name, String place,
        {String? id}) {
      final card = DemoCard(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _FoodTile(icon: icon, color: color, size: 58),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface)),
                  Text(place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  _Badge(context.tr('demo.dju.djassa_pay'), scheme.primary,
                      icon: Icons.qr_code_2),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
          ],
        ),
      );
      return id == target ? DemoTarget(id: id!, child: card) : card;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GradientHeader(
          colors: const [Color(0xFFC94A22), Color(0xFF9E3517)],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('demo.dju.hello'),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        const Text('Abidjan',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars_rounded,
                            size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text('180 pts',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(ios ? 11 : 20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        size: 19, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(context.tr('demo.dju.search'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13.5, color: scheme.onSurfaceVariant)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              shortcut(Icons.local_pharmacy_rounded,
                  context.tr('demo.dju.on_duty'), _pharmacy,
                  live: true, id: 'dju.duty'),
              const SizedBox(width: 10),
              shortcut(Icons.restaurant_rounded, 'Maquis', scheme.primary),
              const SizedBox(width: 10),
              shortcut(Icons.local_offer_rounded, context.tr('demo.dju.deals'),
                  const Color(0xFF75975D)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
          child: Text(context.tr('demo.dju.nearby'),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              maquis(Icons.ramen_dining_rounded, scheme.primary,
                  'Chez Tantie Awa', 'Yopougon · Garba, alloco',
                  id: 'dju.maquis'),
              const SizedBox(height: 10),
              maquis(Icons.set_meal_rounded, const Color(0xFF75975D),
                  'Maquis Le Baobab', 'Marcory · Poisson braisé'),
            ],
          ),
        ),
        const Spacer(),
        const _DjassaTabBar(),
      ],
    );
  }
}

/// Glowing "live" dot on the on-duty shortcut.
class _PulseDot extends StatelessWidget {
  const _PulseDot();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, t, _) => Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFE53935),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFE53935).withOpacity(0.5 * t),
                blurRadius: 6 * t,
                spreadRadius: 2 * t),
          ],
        ),
      ),
    );
  }
}

class _OnDutyPharmacies extends StatelessWidget {
  const _OnDutyPharmacies();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);

    Widget pharmacy(String name, String place) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _pharmacy.withOpacity(0.14),
                  child: const Icon(Icons.local_pharmacy_rounded,
                      size: 20, color: _pharmacy),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface)),
                      Text(place,
                          style: TextStyle(
                              fontSize: 12, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
              decoration: BoxDecoration(
                color: _pharmacy.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.nightlight_round,
                      size: 16, color: _pharmacy),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('demo.dju.duty_label'),
                            style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: _pharmacy)),
                        Text(context.tr('demo.dju.until'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _pharmacy,
                      borderRadius: BorderRadius.circular(ios ? 10 : 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.call_rounded,
                            size: 15, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(context.tr('demo.dju.call'),
                            style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GradientHeader(
          colors: const [_pharmacy, Color(0xFF0B5E3F)],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DemoTarget(
                id: 'dju.back',
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(ios ? Icons.arrow_back_ios_new : Icons.arrow_back,
                      size: 17, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('demo.dju.pharmacies'),
                            style: const TextStyle(
                                fontSize: 21,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(context.tr('demo.dju.pharmacies_sub'),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.local_pharmacy_rounded,
                        color: _pharmacy, size: 26),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              for (final (i, commune) in const [
                'Cocody',
                'Yopougon',
                'Plateau',
              ].indexed) ...[
                if (i > 0) const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: i == 0 ? _pharmacy : null,
                    border: i == 0
                        ? null
                        : Border.all(color: scheme.outlineVariant),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(commune,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: i == 0 ? Colors.white : scheme.onSurface)),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              pharmacy('Pharmacie des Deux Plateaux', 'Cocody · 1,2 km'),
              pharmacy('Pharmacie Saint-Jean', 'Cocody · 2,8 km'),
            ],
          ),
        ),
      ],
    );
  }
}

class _MaquisVenue extends StatelessWidget {
  const _MaquisVenue();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final ios = isIos(context);

    Widget info(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: scheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant)),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            _FoodTile(
                icon: Icons.ramen_dining_rounded,
                color: scheme.primary,
                size: 170,
                wide: true),
            Positioned(
              top: 10,
              left: 12,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black.withOpacity(0.3),
                child: Icon(ios ? Icons.arrow_back_ios_new : Icons.arrow_back,
                    size: 17, color: Colors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Badge('Maquis', scheme.primary, icon: Icons.restaurant),
                  const SizedBox(width: 6),
                  _Badge(context.tr('demo.dju.djassa_pay'), _pharmacy,
                      icon: Icons.qr_code_2),
                ],
              ),
              const SizedBox(height: 8),
              Text('Chez Tantie Awa',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface)),
              Row(
                children: [
                  Icon(Icons.place_outlined,
                      size: 14, color: scheme.onSurfaceVariant),
                  Text(' Yopougon',
                      style: TextStyle(
                          fontSize: 12.5, color: scheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 8),
              DemoCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Column(
                  children: [
                    info(
                        Icons.ramen_dining_rounded,
                        context.tr('demo.dju.specialties'),
                        context.tr('demo.dju.specialties_value')),
                    info(Icons.schedule_rounded, context.tr('demo.dju.hours'),
                        '11:00 – 02:00'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(context.tr('demo.dju.points_here'),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface)),
                  ),
                  const Text('180 pts',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _pharmacy)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.card_giftcard_rounded,
                      size: 16, color: scheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(context.tr('demo.dju.reward'),
                        style:
                            TextStyle(fontSize: 12.5, color: scheme.onSurface)),
                  ),
                  Text('250 pts',
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 180 / 250,
                  minHeight: 6,
                  color: _pharmacy,
                  backgroundColor: _pharmacy.withOpacity(0.15),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: DemoButton(
            label: context.tr('demo.dju.scan'),
            target: 'dju.pay',
            icon: Icons.qr_code_scanner_rounded,
          ),
        ),
      ],
    );
  }
}

class _DjassaUserPaid extends StatelessWidget {
  const _DjassaUserPaid();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Column(
        children: [
          const Spacer(flex: 3),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, t, child) =>
                Transform.scale(scale: t, child: child),
            child: Container(
              width: 84,
              height: 84,
              decoration:
                  const BoxDecoration(color: _pharmacy, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          Text(context.tr('demo.dju.paid'),
              style: TextStyle(fontSize: 15, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(context.money(3500),
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface)),
          const SizedBox(height: 4),
          Text('Chez Tantie Awa · Wave',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 18),
          // Points earned, counted up.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 35),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.13),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded, size: 18, color: scheme.primary),
                  const SizedBox(width: 6),
                  Text('+${v.round()} ${context.tr('demo.dju.points')}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: scheme.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(context.tr('demo.dju.funds'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12, height: 1.4, color: scheme.onSurfaceVariant)),
          const Spacer(flex: 4),
          DemoButton(label: context.tr('demo.dju.done'), target: 'dju.done'),
        ],
      ),
    );
  }
}

/// Stand-in for a venue photo: the brand gradient with scattered dish
/// icons, like the Djassa app's venue banners.
class _FoodTile extends StatelessWidget {
  const _FoodTile({
    required this.icon,
    required this.color,
    required this.size,
    this.wide = false,
  });

  final IconData icon;
  final Color color;
  final double size;

  /// Full-width banner instead of a square thumbnail.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final dark = Color.lerp(color, Colors.black, 0.35)!;
    return Container(
      width: wide ? double.infinity : size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, dark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(wide ? 0 : 12),
      ),
      child: Stack(
        children: [
          if (wide)
            for (final (x, y, i, s) in const [
              (0.08, 0.2, Icons.local_fire_department_rounded, 34.0),
              (0.85, 0.15, Icons.rice_bowl_rounded, 40.0),
              (0.18, 0.85, Icons.local_drink_rounded, 30.0),
              (0.9, 0.85, Icons.set_meal_rounded, 36.0),
            ])
              Align(
                alignment: Alignment(x * 2 - 1, y * 2 - 1),
                child: Icon(i, size: s, color: Colors.white.withOpacity(0.18)),
              ),
          Center(
            child: Icon(icon,
                size: wide ? 72 : size * 0.5,
                color: Colors.white.withOpacity(0.92)),
          ),
        ],
      ),
    );
  }
}
