import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class ImmobilierPage extends StatelessWidget {
  const ImmobilierPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('immo.title')),
        elevation: 0,
        backgroundColor: context.palette.header,
        foregroundColor: context.palette.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              decoration: BoxDecoration(
                gradient: ModernColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Text(
                    tr('immo.title'),
                    style: ModernTypography.displayLarge.copyWith(
                      color: ModernColors.textWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tr('immo.subtitle'),
                    style: ModernTypography.bodyLarge.copyWith(
                      color: ModernColors.textWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('immo.featured'),
                      style: ModernTypography.headlineLarge
                          .copyWith(color: context.palette.textPrimary),
                    ),
                    const SizedBox(height: 32),
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.screenWidth < 600
                            ? 1
                            : (context.screenWidth < 1024 ? 2 : 3),
                        mainAxisExtent: 260,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        _PropertyCard(
                          title: 'immo.p1_title',
                          location: 'immo.p1_location',
                          price: 'immo.p1_price',
                          icon: Icons.apartment,
                        ),
                        _PropertyCard(
                          title: 'immo.p2_title',
                          location: 'immo.p2_location',
                          price: 'immo.p2_price',
                          icon: Icons.home,
                        ),
                        _PropertyCard(
                          title: 'immo.p3_title',
                          location: 'immo.p3_location',
                          price: 'immo.p3_price',
                          icon: Icons.business,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.title,
    required this.location,
    required this.price,
    required this.icon,
  });

  final String title;
  final String location;
  final String price;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(ModernRadius.lg),
        border: Border.all(color: context.palette.border),
        boxShadow: ModernShadows.elevation2,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: context.palette.accent),
          const SizedBox(height: 16),
          Text(
            context.watch<LocaleProvider>().tr(title),
            style: ModernTypography.titleLarge
                .copyWith(color: context.palette.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.watch<LocaleProvider>().tr(location),
            style: ModernTypography.bodyMedium.copyWith(
              color: context.palette.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            context.watch<LocaleProvider>().tr(price),
            style: ModernTypography.titleMedium.copyWith(
              color: ModernColors.accentGreen,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
