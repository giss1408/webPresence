import 'package:flutter/material.dart';

/// Enum for tour tier levels
enum TourTier { budget, premium, vip }

/// Represents a tour package.
///
/// [title], [description], [highlights] and [inclusions] hold translation
/// keys (see `translations.dart`, section "Tour packages"); display them
/// with `localeProvider.tr(...)`.
class TourPackage {
  final String title;
  final TourTier tier;
  final double priceMinFCFA;
  final double priceMaxFCFA;
  final List<int> durations; // 10, 14, 21 days
  final String description;
  final List<String> highlights;
  final List<String> inclusions;
  final Color tierColor;
  final IconData tierIcon;

  const TourPackage({
    required this.title,
    required this.tier,
    required this.priceMinFCFA,
    required this.priceMaxFCFA,
    required this.durations,
    required this.description,
    required this.highlights,
    required this.inclusions,
    required this.tierColor,
    required this.tierIcon,
  });

  /// Approximate USD price (1 USD ≈ 610 FCFA).
  double get priceMinUSD => priceMinFCFA / 610;
}

/// Tour packages for Côte d'Ivoire.
class TourDatabase {
  static List<String> _keys(String tier, String kind, int count) =>
      [for (var i = 1; i <= count; i++) 'tour.$tier.$kind$i'];

  static final List<TourPackage> budgetTours = [
    TourPackage(
      title: 'tour.budget.title',
      tier: TourTier.budget,
      priceMinFCFA: 450000,
      priceMaxFCFA: 650000,
      durations: const [10, 14, 21],
      description: 'tour.budget.desc',
      highlights: _keys('budget', 'h', 6),
      inclusions: _keys('budget', 'inc', 5),
      tierColor: const Color(0xFF00B369),
      tierIcon: Icons.forest,
    ),
  ];

  static final List<TourPackage> premiumTours = [
    TourPackage(
      title: 'tour.premium.title',
      tier: TourTier.premium,
      priceMinFCFA: 1200000,
      priceMaxFCFA: 1800000,
      durations: const [10, 14, 21],
      description: 'tour.premium.desc',
      highlights: _keys('premium', 'h', 6),
      inclusions: _keys('premium', 'inc', 6),
      tierColor: const Color(0xFFFFB700),
      tierIcon: Icons.star_rate,
    ),
  ];

  static final List<TourPackage> vipTours = [
    TourPackage(
      title: 'tour.vip.title',
      tier: TourTier.vip,
      priceMinFCFA: 3000000,
      priceMaxFCFA: 5000000,
      durations: const [10, 14, 21],
      description: 'tour.vip.desc',
      highlights: _keys('vip', 'h', 6),
      inclusions: _keys('vip', 'inc', 8),
      tierColor: const Color(0xFF7C3AED),
      tierIcon: Icons.verified_user,
    ),
  ];
}
