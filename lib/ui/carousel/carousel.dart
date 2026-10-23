import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/section_nav.dart';
import 'package:provider/provider.dart';

import 'animation_slide_up_down_fade.dart';

/// A layer of a slide, placed on the 1200×640 design canvas: an image
/// [asset], or a [widget] drawn in code. [entry] and [exit] are positions
/// on the slide's timeline.
class _Layer {
  final String? asset;
  final Widget? widget;
  final Rect rect;
  final int entry;
  final int exit;

  const _Layer(String this.asset, this.rect, this.entry, this.exit)
      : widget = null;

  const _Layer.widget(Widget this.widget, this.rect, this.entry, this.exit)
      : asset = null;
}

/// A run of slide text with its own style; [key] is a translation key.
class _Span {
  final String key;
  final TextStyle style;

  const _Span(this.key, this.style);
}

class _Slide {
  final List<_Layer> layers;
  final List<_Span> text;
  final int textEntry;
  final int textExit;
  final int timeline;

  const _Slide({
    required this.layers,
    required this.text,
    required this.textEntry,
    required this.textExit,
    required this.timeline,
  });

  /// Timeline position (0–1) at which every layer and the text are visible.
  double get restPoint => (textEntry + 1) / timeline;
}

const double _canvasWidth = 1200;
const double _canvasHeight = 640;
const _deviceFrame = 'assets/images/device_frame.webp';
const _deviceFrameRect = Rect.fromLTWH(441, 37, 317, 565);
const _itemOffset = Offset(0, 60);

/// On phones only this part of the canvas is shown, so the slide is zoomed
/// in instead of shrinking the whole 1200 px canvas to the screen width.
const _mobileViewport = Rect.fromLTRB(240, 40, 960, 600);

/// On phones, layers move this much of the way toward the canvas centre so
/// pictures near the edges stay inside [_mobileViewport].
const _mobilePull = 0.5;

/// Slide text scale on phones, where it wraps within [_mobileViewport].
const _mobileTextScale = 0.7;
const _entryDuration = Duration(milliseconds: 800);
const _exitDuration = Duration(milliseconds: 500);

const List<_Slide> _slides = [
  _Slide(
    timeline: 252,
    textEntry: 36,
    textExit: 219,
    text: [
      _Span('carousel.s1_a', carouselWhiteTextStyle),
      _Span('carousel.s1_b', carouselGreenTextStyle),
    ],
    layers: [
      _Layer('assets/images/abidjan-web.webp',
          Rect.fromLTWH(449, 116, 400, 400), 0, 224),
      _Layer('assets/images/slide_1-layer_1_Test.webp',
          Rect.fromLTWH(222, 60, 760, 480), 14, 231),
      _Layer('assets/images/slide_1-layer_2_Test.webp',
          Rect.fromLTWH(374, 148, 596, 368), 26, 238),
    ],
  ),
  // Second line of work: technical due diligence for investors.
  _Slide(
    timeline: 200,
    textEntry: 34,
    textExit: 159,
    text: [
      _Span('carousel.dd_a', carouselWhiteTextStyle),
      _Span('carousel.dd_b', carouselOrangeTextStyle),
    ],
    layers: [
      _Layer.widget(_ReportScreen(), Rect.fromLTWH(458, 54, 283, 531), 0, 164),
      _Layer.widget(_FindingCard(_Level.crit, 'carousel.dd_f2'),
          Rect.fromLTWH(140, 400, 300, 100), 14, 172),
      _Layer.widget(_DeliveryCard(), Rect.fromLTWH(770, 130, 290, 96), 24, 178),
    ],
  ),
  _Slide(
    timeline: 200,
    textEntry: 33,
    textExit: 159,
    text: [
      _Span('carousel.s2_a', carouselWhiteTextStyle),
      _Span('carousel.s2_b', carouselGreenTextStyle),
    ],
    layers: [
      _Layer('assets/images/woman-4873600_1280.Layer_Test_1.webp',
          Rect.fromLTWH(46, 106, 385, 467), 0, 164),
      _Layer('assets/images/Layer_Test_1.webp',
          Rect.fromLTWH(400, 100, 714, 298), 17, 178),
      _Layer('assets/images/Layer_Test_2.webp',
          Rect.fromLTWH(114, 105, 901, 396), 13, 172),
    ],
  ),
  _Slide(
    timeline: 200,
    textEntry: 34,
    textExit: 157,
    text: [
      _Span('carousel.s3_a', carouselWhiteTextStyle),
      _Span('carousel.s3_b', carouselOrangeTextStyle),
    ],
    layers: [
      _Layer('assets/images/stock-market-2616931_1280.webp',
          Rect.fromLTWH(400, 117, 420, 395), 0, 162),
      _Layer('assets/images/slide_3-layer_2_Test.webp',
          Rect.fromLTWH(260, 95, 801, 429), 12, 169),
      _Layer('assets/images/slide_3-layer_1_Test.webp',
          Rect.fromLTWH(194, 73, 906, 440), 23, 175),
    ],
  ),
  _Slide(
    timeline: 200,
    textEntry: 37,
    textExit: 159,
    text: [
      _Span('carousel.s4_a', carouselBrownTextStyle),
      _Span('carousel.s4_b', carouselWhiteTextStyle),
      _Span('carousel.s4_c', carouselBrownTextStyle),
    ],
    layers: [
      _Layer('assets/images/blackWoman_layer_4_1280.webp',
          Rect.fromLTWH(345, 52, 345, 480), 0, 166),
      _Layer('assets/images/slide_4-layer_1_Test.webp',
          Rect.fromLTWH(202, 108, 735, 428), 14, 176),
      _Layer('assets/images/slide_4-layer_2_Test.webp',
          Rect.fromLTWH(187, 80, 901, 474), 25, 171),
    ],
  ),
  // Fifth slide: a direct challenge to try the product, no screenshot —
  // just the pitch card. Pulled up near the top of the canvas so roughly
  // 3/4 of it sits above the headline's vertical centre; only the card's
  // empty bottom margin falls under the headline.
  _Slide(
    timeline: 200,
    textEntry: 20,
    textExit: 180,
    text: [
      _Span('carousel.s5_a', carouselWhiteTextStyle),
      _Span('carousel.s5_b', carouselBlueTextStyle),
    ],
    layers: [
      _Layer.widget(_PitchCard(), Rect.fromLTWH(740, 40, 400, 320), 0, 200),
    ],
  ),
];

/// Home page hero: an auto-playing layered carousel with dot navigation,
/// swipe, pause on hover / pause button, and a call to action.
class Carousel extends StatefulWidget {
  static const slideDuration = Duration(milliseconds: 6400);

  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _index = 0;

  /// Indexes of the visible layers; `layers.length` stands for the text.
  Set<int> _visible = const {};
  bool _hovered = false;
  bool _userPaused = false;
  bool _initialized = false;

  _Slide get _slide => _slides[_index];
  bool get _paused => _hovered || _userPaused;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Carousel.slideDuration)
          ..addListener(_syncVisibility)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _goTo(_index + 1);
          });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    // Decode every slide image up front so layers never pop in late.
    for (final slide in _slides) {
      for (final layer in slide.layers) {
        if (layer.asset != null) {
          precacheImage(AssetImage(layer.asset!), context);
        }
      }
    }
    precacheImage(const AssetImage(_deviceFrame), context);

    // Respect the OS "reduce motion" setting: start paused on a full slide.
    _userPaused = MediaQuery.disableAnimationsOf(context);
    _goTo(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncVisibility() {
    final position = _controller.value * _slide.timeline;
    final visible = <int>{
      for (var i = 0; i < _slide.layers.length; i++)
        if (position >= _slide.layers[i].entry &&
            position < _slide.layers[i].exit)
          i,
      if (position >= _slide.textEntry && position < _slide.textExit)
        _slide.layers.length,
    };
    // Only rebuild when a layer appears or disappears, not on every tick.
    if (!setEquals(visible, _visible)) setState(() => _visible = visible);
  }

  void _goTo(int index) {
    setState(() {
      _index = index % _slides.length;
      _visible = const {};
    });
    // While paused, show the slide fully instead of an empty frame.
    _controller.value = _paused ? _slide.restPoint : 0;
    if (!_paused) _controller.forward();
  }

  void _setHovered(bool hovered) {
    _hovered = hovered;
    _updatePlayback();
  }

  void _togglePause() {
    setState(() => _userPaused = !_userPaused);
    _updatePlayback();
  }

  void _updatePlayback() {
    if (_paused) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.forward();
    }
  }

  void _onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -250) _goTo(_index + 1);
    if (velocity > 250) _goTo(_index + _slides.length - 1);
  }

  Widget _animated(int id, Widget child) {
    final visible = _visible.contains(id);
    return WidgetSlideUpDownFadeAnimation(
      duration: visible ? _entryDuration : _exitDuration,
      direction: visible,
      offset: _itemOffset,
      child: child,
    );
  }

  /// [rect] moved toward the canvas centre, keeping its size.
  static Rect _pulledIn(Rect rect) {
    const centreX = _canvasWidth / 2;
    return rect.translate((centreX - rect.center.dx) * _mobilePull, 0);
  }

  Widget _buildSlide(String Function(String) tr, {required bool isMobile}) {
    final slide = _slide;
    return SizedBox(
      width: _canvasWidth,
      height: _canvasHeight,
      child: Stack(
        children: [
          for (var i = 0; i < slide.layers.length; i++)
            Positioned.fromRect(
              rect: isMobile
                  ? _pulledIn(slide.layers[i].rect)
                  : slide.layers[i].rect,
              child: _animated(
                  i,
                  slide.layers[i].widget ??
                      Image.asset(slide.layers[i].asset!, fit: BoxFit.fill)),
            ),
          Positioned.fromRect(
            rect: _deviceFrameRect,
            child: Image.asset(_deviceFrame, fit: BoxFit.fill),
          ),
          Positioned.fromRect(
            rect: isMobile
                ? _mobileViewport.deflate(24)
                : const Rect.fromLTRB(24, 0, _canvasWidth - 24, _canvasHeight),
            child: Center(
              child: _animated(
                slide.layers.length,
                RichText(
                  textAlign: TextAlign.center,
                  textScaler: isMobile
                      ? const TextScaler.linear(_mobileTextScale)
                      : TextScaler.noScaling,
                  text: TextSpan(
                    style: const TextStyle(height: 1.1),
                    children: [
                      for (final span in slide.text)
                        TextSpan(text: tr(span.key), style: span.style),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: DecoratedBox(
        // The hero keeps its own dark stage in both themes so the white
        // slide text always has contrast.
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.1,
            colors: [Color(0xFF1C2B4B), backgroundDark],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isMobile = width < 768;
            // Phones show the zoomed-in viewport; desktop keeps canvas +
            // controls + CTA above the fold.
            final canvasHeight = isMobile
                ? width * _mobileViewport.height / _mobileViewport.width
                : math.min(
                    width * _canvasHeight / _canvasWidth,
                    (screenHeight - 72) * 0.72,
                  );
            final slide = AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: _buildSlide(tr, isMobile: isMobile),
              ),
            );

            return Column(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: _onSwipe,
                  child: SizedBox(
                    width: width,
                    height: canvasHeight,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      clipBehavior: Clip.hardEdge,
                      child: isMobile
                          ? SizedBox.fromSize(
                              size: _mobileViewport.size,
                              child: Stack(
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  Positioned(
                                    left: -_mobileViewport.left,
                                    top: -_mobileViewport.top,
                                    width: _canvasWidth,
                                    height: _canvasHeight,
                                    child: slide,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              width: _canvasWidth,
                              height: _canvasHeight,
                              child: slide,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildControls(isMobile, tr),
                SizedBox(height: isMobile ? 28 : 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls(bool isMobile, String Function(String) tr) {
    return RepaintBoundary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isMobile)
            _ControlButton(
              icon: Icons.chevron_left,
              tooltip: tr('carousel.previous'),
              onTap: () => _goTo(_index + _slides.length - 1),
            ),
          for (var i = 0; i < _slides.length; i++)
            _Dot(
              active: i == _index,
              progress: _controller,
              label: '${tr('carousel.slide')} ${i + 1}',
              onTap: () => _goTo(i),
            ),
          _ControlButton(
            icon: _userPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            tooltip: tr(_userPaused ? 'carousel.play' : 'carousel.pause'),
            onTap: _togglePause,
          ),
          if (!isMobile)
            _ControlButton(
              icon: Icons.chevron_right,
              tooltip: tr('carousel.next'),
              onTap: () => _goTo(_index + 1),
            ),
        ],
      ),
    );
  }
}

/// Slide indicator. The active dot stretches into a bar that fills up with
/// the slide's progress.
class _Dot extends StatelessWidget {
  final bool active;
  final Animation<double> progress;
  final String label;
  final VoidCallback onTap;

  const _Dot({
    required this.active,
    required this.progress,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 36,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: active ? 40 : 10,
                  height: 10,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(active ? 0.25 : 0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.centerLeft,
                  child: active
                      ? AnimatedBuilder(
                          animation: progress,
                          builder: (context, _) => FractionallySizedBox(
                            widthFactor: progress.value,
                            heightFactor: 1,
                            child: const ColoredBox(color: Colors.white),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      icon: Icon(icon),
      color: Colors.white.withOpacity(0.8),
      hoverColor: Colors.white.withOpacity(0.1),
      iconSize: 22,
    );
  }
}

// ── Due diligence slide ─────────────────────────────────────────────
// Drawn in code rather than as images so the sample report is translated.
// Dark surfaces keep the white slide text readable on top of them.

const _ddSurface = Color(0xFF13203A);
const _ddBorder = Color(0x33FFFFFF);
const _ddMuted = Color(0xB3FFFFFF);

enum _Level {
  crit('carousel.dd_crit', Color(0xFFFF6B6B)),
  warn('carousel.dd_warn', Color(0xFFFFB020)),
  good('carousel.dd_good', Color(0xFF3DDC84));

  final String key;
  final Color color;

  const _Level(this.key, this.color);
}

class _LevelChip extends StatelessWidget {
  final _Level level;

  const _LevelChip(this.level);

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: level.color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tr(level.key),
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: level.color,
        ),
      ),
    );
  }
}

/// The phone screen: page 1 of a sample report.
class _ReportScreen extends StatelessWidget {
  const _ReportScreen();

  static const _findings = [
    (_Level.crit, 'carousel.dd_f1'),
    (_Level.crit, 'carousel.dd_f2'),
    (_Level.warn, 'carousel.dd_f3'),
    (_Level.good, 'carousel.dd_f4'),
  ];

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    const body = TextStyle(
        fontFamily: fontFamily, fontSize: 14, color: Colors.white, height: 1.3);
    // Dimmed: it is the backdrop, the slide headline sits on top of it.
    return Container(
      foregroundDecoration: BoxDecoration(
        color: _ddSurface.withOpacity(0.45),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.fromLTRB(22, 64, 22, 22),
      decoration: BoxDecoration(
        color: _ddSurface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('carousel.dd_sample'),
              style: body.copyWith(fontSize: 12, color: _ddMuted)),
          const SizedBox(height: 6),
          Text(tr('carousel.dd_title'),
              style: body.copyWith(fontSize: 19, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          for (final (level, key) in _findings) ...[
            _LevelChip(level),
            const SizedBox(height: 6),
            Text(tr(key), style: body),
            const SizedBox(height: 16),
          ],
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: _ddBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tr('carousel.dd_verdict'),
                style: body.copyWith(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final Color accent;
  final Widget child;

  const _FloatingCard({required this.accent, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _ddSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }
}

/// One finding pulled out of the report.
class _FindingCard extends StatelessWidget {
  final _Level level;
  final String textKey;

  const _FindingCard(this.level, this.textKey);

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    return _FloatingCard(
      accent: level.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LevelChip(level),
          const SizedBox(height: 8),
          Text(tr(textKey),
              style: const TextStyle(
                  fontFamily: fontFamily, fontSize: 17, color: Colors.white)),
        ],
      ),
    );
  }
}

/// What the investor gets, and how fast.
class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard();

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    return _FloatingCard(
      accent: const Color(0xFF008AFE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(tr('carousel.dd_report'),
              style: const TextStyle(
                  fontFamily: fontFamily, fontSize: 12, color: _ddMuted)),
          const SizedBox(height: 6),
          Text(tr('carousel.dd_delivery'),
              style: const TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

/// A short point in the "put us to the test" pitch card, with a check mark
/// in the same blue as the card's accent.
class _PitchPoint extends StatelessWidget {
  final String textKey;

  const _PitchPoint(this.textKey);

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 18, color: Color(0xFF008AFE)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(tr(textKey),
              style: const TextStyle(
                  fontFamily: fontFamily, fontSize: 14, color: Colors.white)),
        ),
      ],
    );
  }
}

/// The "put us to the test" pitch card: a direct challenge, two reasons why
/// it's low-risk, and a CTA — blue to match [carouselBlueTextStyle].
class _PitchCard extends StatelessWidget {
  const _PitchCard();

  static const _points = ['carousel.s5_point1', 'carousel.s5_point2'];

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _ddSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF008AFE), width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33008AFE), blurRadius: 32, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final key in _points) ...[
            _PitchPoint(key),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => scrollToSection(context, HomeSections.contact),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF008AFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(tr('carousel.s5_cta'),
                    style: const TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
