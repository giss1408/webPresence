import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_website/components/app_palette.dart';
import 'package:flutter_website/components/motion.dart';
import 'package:flutter_website/components/typography.dart';

/// Brand text that runs out of the R mark.
const brandText = 'Mobile Business Technologies';

/// Flag of Côte d'Ivoire, as in the mark: the first word is orange, the
/// last green, the middle one keeps the text color (the flag's white band).
const _orange = Color(0xFFF77F00);
const _green = Color(0xFF009E60);

/// The R mark followed by [brandText], typed out from the R behind an amber
/// cursor that then blinks and stays.
///
/// Plays once when first on screen and again on hover. With the OS "reduce
/// motion" setting, shows the finished logo.
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({
    super.key,
    this.markSize = 36,
    this.fontSize = 17,
    this.textColor,
    this.showText = true,
  });

  final double markSize;
  final double fontSize;

  /// Defaults to the theme's primary text color.
  final Color? textColor;
  final bool showText;

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  // 0–0.6: the text is typed out; 0.6–1: the cursor blinks, ends visible.
  static const _typedAt = 0.6;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    // Outside the scrolling page (the app bar), play on the first frame;
    // OnScreen only handles logos the page scrolls into view (the footer).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Scrollable.maybeOf(context) == null) _play();
    });
  }

  void _play() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mark = SvgPicture.asset('assets/images/logo.svg',
        height: widget.markSize, width: widget.markSize, fit: BoxFit.contain);
    if (!widget.showText) return mark;

    final cursorWidth = widget.fontSize * 0.55;
    return OnScreen(
      onChanged: (visible) {
        if (visible) _play();
      },
      child: MouseRegion(
        onEnter: (_) => _play(),
        child: Semantics(
          label: brandText,
          excludeSemantics: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              mark,
              SizedBox(width: widget.fontSize * 0.5),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  final typed = Curves.easeOutCubic
                      .transform((t / _typedAt).clamp(0.0, 1.0));
                  // Blinks three times after typing, then stays on.
                  final blinkPhase = ((t - _typedAt) / 0.08).floor();
                  final cursorOn = t < _typedAt || t >= 1 || blinkPhase.isOdd;
                  return Stack(
                    children: [
                      ClipRect(
                        clipper: _RevealClipper(typed, cursorWidth),
                        child: Padding(
                          padding: EdgeInsets.only(right: cursorWidth + 2),
                          child: Text.rich(
                            TextSpan(children: [
                              for (final (i, word)
                                  in brandText.split(' ').indexed)
                                TextSpan(
                                  text: i == 0 ? word : ' $word',
                                  style: i == 0
                                      ? const TextStyle(color: _orange)
                                      : i == 2
                                          ? const TextStyle(color: _green)
                                          : null,
                                ),
                            ]),
                            maxLines: 1,
                            softWrap: false,
                            style: headlineSecondaryTextStyle.copyWith(
                                fontSize: widget.fontSize,
                                fontWeight: FontWeight.w700,
                                color: widget.textColor ?? palette.textPrimary),
                          ),
                        ),
                      ),
                      // The cursor rides the edge of the revealed text.
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment(-1 + 2 * typed, 0.72),
                          child: Opacity(
                            opacity: cursorOn ? 1 : 0,
                            child: Container(
                              width: cursorWidth,
                              height: widget.fontSize * 0.2,
                              decoration: BoxDecoration(
                                color: _orange,
                                borderRadius:
                                    BorderRadius.circular(widget.fontSize),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the left [fraction] of the text, up to the cursor's left edge.
class _RevealClipper extends CustomClipper<Rect> {
  _RevealClipper(this.fraction, this.cursorWidth);

  final double fraction;
  final double cursorWidth;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, (size.width - cursorWidth) * fraction, size.height);

  @override
  bool shouldReclip(_RevealClipper old) => old.fraction != fraction;
}
