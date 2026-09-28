import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/showcase/demo_kit.dart';
import 'package:provider/provider.dart';

const _green = Color(0xFF16A34A);
const _orange = Color(0xFFF59E0B);
const _blue = Color(0xFF1389FD);
const _loop = 14.0; // seconds

/// When each sale is recorded on the phone and when it reaches the server
/// (seconds into the loop). Sale 0 syncs at once; the network is down from
/// [_offlineAt] to [_onlineAt], so sales 1–3 wait in the queue.
const _sales = [
  (product: 'sync.p1', amount: 4500, recorded: 0.8, arrives: 2.0),
  (product: 'sync.p2', amount: 1800, recorded: 4.2, arrives: 9.4),
  (product: 'sync.p3', amount: 900, recorded: 5.6, arrives: 10.0),
  (product: 'sync.p4', amount: 2500, recorded: 7.0, arrives: 10.6),
];
const _offlineAt = 3.0;
const _onlineAt = 8.6;
const _travel = 0.9; // seconds a sale takes to reach the server
const _serverBase = 128;

enum _Link { online, offline, syncing, synced }

/// "Offline-first" section: an animated scene of a phone recording sales
/// while the network drops, queueing them, and syncing them to the server
/// when it returns. Loops while on screen.
class OfflineSyncDemo extends StatefulWidget {
  const OfflineSyncDemo({super.key});

  @override
  State<OfflineSyncDemo> createState() => _OfflineSyncDemoState();
}

class _OfflineSyncDemoState extends State<OfflineSyncDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 14000),
  );

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  void _onVisible(bool visible) {
    if (MediaQuery.disableAnimationsOf(context)) {
      // Still frame: queue flushed, everything synced.
      _clock.value = 12 / _loop;
    } else if (visible) {
      _clock.repeat();
    } else {
      _clock.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    final palette = context.palette;
    final isDesktop = context.isDesktop;
    final isNarrow = context.screenWidth < 520;

    final text = Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: palette.accentSoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(tr('sync.badge'),
              style: bodyTextStyle.copyWith(
                  fontSize: 11,
                  color: palette.accent,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 18),
        Text(
          tr('sync.title'),
          style: headlineTextStyle.copyWith(
              fontSize: isNarrow ? 26 : 32, height: 1.2),
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          tr('sync.body'),
          style: bodyTextStyle.copyWith(
              fontSize: 16, color: palette.textSecondary, height: 1.7),
          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _clock,
          builder: (context, _) {
            final t = _clock.value * _loop;
            final phase = t < _offlineAt ? 0 : (t < _onlineAt ? 1 : 2);
            return Column(
              children: [
                for (final (i, key) in const [
                  'sync.phase1',
                  'sync.phase2',
                  'sync.phase3',
                ].indexed)
                  _Phase(number: i + 1, text: tr(key), active: i == phase),
              ],
            );
          },
        ),
      ],
    );

    return OnScreen(
      once: false,
      onChanged: _onVisible,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: palette.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        margin: blockMargin,
        padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : (isNarrow ? 16 : 32),
            vertical: isDesktop ? 64 : 44),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: text),
                  const SizedBox(width: 48),
                  Expanded(child: _Scene(clock: _clock)),
                ],
              )
            : Column(
                children: [
                  text,
                  const SizedBox(height: 32),
                  _Scene(clock: _clock),
                ],
              ),
      ),
    );
  }
}

class _Phase extends StatelessWidget {
  const _Phase(
      {required this.number, required this.text, required this.active});

  final int number;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: active ? palette.surface : Colors.transparent,
        border: Border.all(color: active ? palette.accent : Colors.transparent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? palette.accent : palette.accentSoft,
            ),
            child: Text('$number',
                style: bodyTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.white : palette.accent)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: bodyTextStyle.copyWith(
                    fontSize: 14.5,
                    height: 1.45,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color:
                        active ? palette.textPrimary : palette.textSecondary)),
          ),
        ],
      ),
    );
  }
}

/// Phone → link → server, laid out in a row, or a column on narrow screens.
class _Scene extends StatelessWidget {
  const _Scene({required this.clock});

  final Animation<double> clock;

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    final locale = context.watch<LocaleProvider>().locale;
    final palette = context.palette;

    return LayoutBuilder(builder: (context, constraints) {
      final vertical = constraints.maxWidth < 460;
      return AnimatedBuilder(
        animation: clock,
        builder: (context, _) {
          final t = clock.value * _loop;
          final link = t < _offlineAt
              ? _Link.online
              : t < _onlineAt
                  ? _Link.offline
                  : t < _sales.last.arrives
                      ? _Link.syncing
                      : _Link.synced;
          final recorded = [
            for (final s in _sales)
              if (t >= s.recorded) s
          ];
          final pending = recorded.where((s) => t < s.arrives).length;
          final onServer =
              _serverBase + _sales.where((s) => t >= s.arrives).length;
          // Sales travelling to the server right now, as 0–1 progress.
          final packets = [
            for (final s in _sales)
              if (t >= s.arrives - _travel && t < s.arrives)
                1 - (s.arrives - t) / _travel,
          ];

          final (statusColor, statusText, statusIcon) = switch (link) {
            _Link.online => (_green, tr('demo.dj.online'), Icons.wifi),
            _Link.offline => (_orange, tr('demo.dj.offline'), Icons.wifi_off),
            _Link.syncing => (_blue, tr('sync.syncing'), Icons.sync),
            _Link.synced => (_green, tr('sync.synced'), Icons.cloud_done),
          };

          final phone = _Panel(
            icon: Icons.phone_android,
            title: '${tr('sync.phone')} · Djassa',
            child: Column(
              children: [
                for (final s in recorded.reversed)
                  _SaleLine(
                    key: ValueKey(s.product),
                    label: tr(s.product),
                    amount: fcfa(s.amount, locale),
                    synced: t >= s.arrives,
                  ),
                if (recorded.isEmpty)
                  SizedBox(
                    height: 34,
                    child: Center(
                      child: Text('…',
                          style:
                              bodyTextStyle.copyWith(color: palette.textMuted)),
                    ),
                  ),
              ],
            ),
          );

          final server = _Panel(
            icon: Icons.dns_outlined,
            title: tr('sync.server'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Text('$onServer',
                        key: ValueKey(onServer),
                        style: headlineTextStyle.copyWith(
                            fontSize: 34, fontWeight: FontWeight.bold)),
                  ),
                  Text(tr('sync.recorded'),
                      textAlign: TextAlign.center,
                      style: bodyTextStyle.copyWith(
                          fontSize: 12, color: palette.textMuted)),
                ],
              ),
            ),
          );

          final connection = SizedBox(
            width: vertical ? 64 : null,
            height: vertical ? 90 : 64,
            child: CustomPaint(
              painter: _LinkPainter(
                vertical: vertical,
                connected: link != _Link.offline,
                color: link == _Link.offline ? palette.border : statusColor,
                packets: packets,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 2),
                  ),
                  child: Icon(statusIcon, size: 16, color: statusColor),
                ),
              ),
            ),
          );

          final status = Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 6),
                    Text(statusText,
                        style: bodyTextStyle.copyWith(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: statusColor)),
                  ],
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: pending > 0 ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Text(tr('sync.pending').replaceAll('{n}', '$pending'),
                    style: bodyTextStyle.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _orange)),
              ),
            ],
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              status,
              const SizedBox(height: 16),
              if (vertical) ...[
                phone,
                connection,
                server,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: phone),
                    Expanded(flex: 2, child: connection),
                    Expanded(flex: 3, child: server),
                  ],
                ),
            ],
          );
        },
      );
    });
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.icon, required this.title, required this.child});

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: palette.accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyTextStyle.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: palette.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Room for four sales, so the scene doesn't jump as they arrive.
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 150),
            child: Align(alignment: Alignment.topCenter, child: child),
          ),
        ],
      ),
    );
  }
}

class _SaleLine extends StatelessWidget {
  const _SaleLine({
    super.key,
    required this.label,
    required this.amount,
    required this.synced,
  });

  final String label;
  final String amount;
  final bool synced;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child:
            Transform.translate(offset: Offset(0, -10 * (1 - v)), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bodyTextStyle.copyWith(
                      fontSize: 13, color: palette.textPrimary)),
            ),
            const SizedBox(width: 6),
            Text(amount,
                style: bodyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: palette.textSecondary)),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(synced ? Icons.check_circle : Icons.schedule,
                  key: ValueKey(synced),
                  size: 16,
                  color: synced ? _green : _orange),
            ),
          ],
        ),
      ),
    );
  }
}

/// The connection: a solid line while connected, dashed while offline, with
/// sales travelling along it as dots.
class _LinkPainter extends CustomPainter {
  _LinkPainter({
    required this.vertical,
    required this.connected,
    required this.color,
    required this.packets,
  });

  final bool vertical;
  final bool connected;
  final Color color;
  final List<double> packets;

  @override
  void paint(Canvas canvas, Size size) {
    final start =
        vertical ? Offset(size.width / 2, 0) : Offset(0, size.height / 2);
    final end = vertical
        ? Offset(size.width / 2, size.height)
        : Offset(size.width, size.height / 2);
    final line = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    if (connected) {
      canvas.drawLine(start, end, line);
    } else {
      const dash = 6.0;
      final length = (end - start).distance;
      final direction = (end - start) / length;
      for (var d = 0.0; d < length; d += dash * 2) {
        canvas.drawLine(start + direction * d,
            start + direction * (d + dash).clamp(0, length), line);
      }
    }
    final dot = Paint()..color = color;
    for (final p in packets) {
      final at = Offset.lerp(start, end, Curves.easeInOut.transform(p))!;
      canvas.drawCircle(at, 7, Paint()..color = color.withOpacity(0.25));
      canvas.drawCircle(at, 4.5, dot);
    }
  }

  @override
  bool shouldRepaint(_LinkPainter old) =>
      old.connected != connected ||
      old.color != color ||
      old.vertical != vertical ||
      old.packets.join() != packets.join();
}
