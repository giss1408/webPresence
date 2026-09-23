import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/services/whatsapp_service.dart';
import 'package:provider/provider.dart';

import 'animation_slide_up_down_fade.dart';

/// An image layer of a slide, placed on the 1200×640 design canvas.
/// [entry] and [exit] are positions on the slide's timeline.
class _Layer {
  final String asset;
  final Rect rect;
  final int entry;
  final int exit;

  const _Layer(this.asset, this.rect, this.entry, this.exit);
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
const _deviceFrame = 'assets/images/device_frame.png';
const _deviceFrameRect = Rect.fromLTWH(441, 37, 317, 565);
const _itemOffset = Offset(0, 60);
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
      _Layer('assets/images/abidjan-web.jpg', Rect.fromLTWH(449, 116, 400, 400),
          0, 224),
      _Layer('assets/images/slide_1-layer_1_Test.png',
          Rect.fromLTWH(222, 60, 760, 480), 14, 231),
      _Layer('assets/images/slide_1-layer_2_Test.png',
          Rect.fromLTWH(374, 148, 596, 368), 26, 238),
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
      _Layer('assets/images/woman-4873600_1280.Layer_Test_1.jpg',
          Rect.fromLTWH(46, 106, 385, 467), 0, 164),
      _Layer('assets/images/Layer_Test_1.png',
          Rect.fromLTWH(400, 100, 714, 298), 17, 178),
      _Layer('assets/images/Layer_Test_2.png',
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
      _Layer('assets/images/stock-market-2616931_1280.jpg',
          Rect.fromLTWH(400, 117, 420, 395), 0, 162),
      _Layer('assets/images/slide_3-layer_2_Test.png',
          Rect.fromLTWH(260, 95, 801, 429), 12, 169),
      _Layer('assets/images/slide_3-layer_1_Test.png',
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
      _Layer('assets/images/blackWoman_layer_4_1280.jpg',
          Rect.fromLTWH(345, 52, 345, 480), 0, 166),
      _Layer('assets/images/slide_4-layer_1_Test.png',
          Rect.fromLTWH(202, 108, 735, 428), 14, 176),
      _Layer('assets/images/slide_4-layer_2_Test.png',
          Rect.fromLTWH(187, 80, 901, 474), 25, 171),
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
        precacheImage(AssetImage(layer.asset), context);
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

  Widget _buildSlide(String Function(String) tr) {
    final slide = _slide;
    return SizedBox(
      width: _canvasWidth,
      height: _canvasHeight,
      child: Stack(
        children: [
          for (var i = 0; i < slide.layers.length; i++)
            Positioned.fromRect(
              rect: slide.layers[i].rect,
              child: _animated(
                  i, Image.asset(slide.layers[i].asset, fit: BoxFit.fill)),
            ),
          Positioned.fromRect(
            rect: _deviceFrameRect,
            child: Image.asset(_deviceFrame, fit: BoxFit.fill),
          ),
          Positioned.fill(
            left: 24,
            right: 24,
            child: Center(
              child: _animated(
                slide.layers.length,
                RichText(
                  textAlign: TextAlign.center,
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
            // On desktop, keep canvas + controls + CTA above the fold.
            final canvasHeight = math.min(
              width * _canvasHeight / _canvasWidth,
              isMobile ? double.infinity : (screenHeight - 66) * 0.72,
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
                      child: SizedBox(
                        width: _canvasWidth,
                        height: _canvasHeight,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: KeyedSubtree(
                            key: ValueKey(_index),
                            child: _buildSlide(tr),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildControls(isMobile, tr),
                const SizedBox(height: 16),
                _HeroButton(
                  label: tr('gs.cta_primary'),
                  onPressed: () =>
                      WhatsAppService.openWhatsApp(message: tr('wa.project')),
                ),
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

class _HeroButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _HeroButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.hovered) ? buttonPrimaryDark : null,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: buttonTextStyle.copyWith(fontSize: 16)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    );
  }
}
