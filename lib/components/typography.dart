import 'package:flutter/material.dart';

import 'components.dart';

const String fontFamily = "Brand Sans";

/// Bundled glyphs our fonts lack (→ ✓ ≈, narrow no-break space): without
/// this fallback, Flutter fetches fonts from Google for them.
const List<String> symbolFallback = ['SiteSymbols'];

// Simple
const TextStyle headlineTextStyle = TextStyle(
    fontSize: 44,
    height: 1.2,
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5);

const TextStyle headlineSecondaryTextStyle = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3);

// No color: text inherits the page's DefaultTextStyle, which follows the
// light / dark palette.
const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    height: 1.6,
    fontFamily: "Roboto",
    fontFamilyFallback: symbolFallback);

TextStyle bodyLinkTextStyle = bodyTextStyle.copyWith(color: primary);

const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18, color: Colors.white, height: 1, fontFamily: fontFamily);

// Carousel
const TextStyle carouselBlueTextStyle = TextStyle(
    fontSize: 100,
    color: Color(0xFF008AFE),
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    shadows: [
      Shadow(
        color: Color(0x80000000),
        offset: Offset(0, 2),
        blurRadius: 12,
      )
    ]);

const TextStyle carouselGreenTextStyle = TextStyle(
    fontSize: 100,
    color: Color(0xFF008000),
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    shadows: [
      Shadow(
        color: Color(0x80000000),
        offset: Offset(0, 2),
        blurRadius: 12,
      )
    ]);

const TextStyle carouselOrangeTextStyle = TextStyle(
    fontSize: 100,
    color: Color(0xFFFF8800),
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    shadows: [
      Shadow(
        color: Color(0x80000000),
        offset: Offset(0, 2),
        blurRadius: 12,
      )
    ]);

const TextStyle carouselBrownTextStyle = TextStyle(
    fontSize: 100,
    // Warm terracotta — the former dark brown had no contrast on the dark hero.
    color: Color(0xFFE0874F),
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    shadows: [
      Shadow(
        color: Color(0x80000000),
        offset: Offset(0, 2),
        blurRadius: 12,
      )
    ]);

const TextStyle carouselWhiteTextStyle = TextStyle(
    fontSize: 100,
    color: Colors.white,
    fontFamily: fontFamily,
    fontFamilyFallback: symbolFallback,
    shadows: [
      Shadow(
        color: Color(0x80000000),
        offset: Offset(0, 2),
        blurRadius: 12,
      )
    ]);
