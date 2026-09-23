import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:provider/provider.dart';

/// Highlight card for tourism features
class HighlightCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? imageUrl;

  const HighlightCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.imageUrl,
  });

  @override
  State<HighlightCard> createState() => _HighlightCardState();
}

class _HighlightCardState extends State<HighlightCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.03).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(ModernRadius.lg),
            border: Border.all(
              color: _isHovered ? widget.color : context.palette.border,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withAlpha(51), // 20%
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ]
                : ModernShadows.elevation2,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image or Icon
                if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ModernRadius.md),
                    child: Image.asset(
                      widget.imageUrl!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconContainer();
                      },
                    ),
                  )
                else
                  _buildIconContainer(),
                const SizedBox(height: 16),
                // Title
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: ModernTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: ModernTypography.bodyMedium.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: widget.color.withAlpha(26), // 10%
        borderRadius: BorderRadius.circular(ModernRadius.md),
      ),
      child: Icon(
        widget.icon,
        color: widget.color,
        size: 32,
      ),
    );
  }
}

/// Grid display of tourism highlights
class HighlightsGrid extends StatelessWidget {
  const HighlightsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width < 600 ? 1 : (width < 1024 ? 2 : 3);

    final highlights = [
      {
        'title': localeProvider.tr('highlight.cultural'),
        'description': localeProvider.tr('highlight.cultural_desc'),
        'icon': Icons.palette,
        'color': const Color(0xFF7C3AED), // Purple
        'image': 'assets/images/highlights/highlight_cultural.jpg',
      },
      {
        'title': localeProvider.tr('highlight.wildlife'),
        'description': localeProvider.tr('highlight.wildlife_desc'),
        'icon': Icons.forest,
        'color': const Color(0xFF00B369), // Green
        'image': 'assets/images/highlights/highlight_wildlife.jpg',
      },
      {
        'title': localeProvider.tr('highlight.beach'),
        'description': localeProvider.tr('highlight.beach_desc'),
        'icon': Icons.beach_access,
        'color': const Color(0xFF00D9FF), // Teal
        'image': 'assets/images/highlights/highlight_beach.jpg',
      },
      {
        'title': localeProvider.tr('highlight.cuisine'),
        'description': localeProvider.tr('highlight.cuisine_desc'),
        'icon': Icons.restaurant,
        'color': const Color(0xFFFF6B35), // Orange
        'image': 'assets/images/highlights/highlight_cuisine.jpg',
      },
      {
        'title': localeProvider.tr('highlight.adventure'),
        'description': localeProvider.tr('highlight.adventure_desc'),
        'icon': Icons.landscape,
        'color': const Color(0xFFFFB700), // Gold
        'image': 'assets/images/highlights/highlight_adventure.jpg',
      },
      {
        'title': localeProvider.tr('highlight.photography'),
        'description': localeProvider.tr('highlight.photography_desc'),
        'icon': Icons.photo_camera,
        'color': const Color(0xFF1389FD), // Blue
        'image': 'assets/images/highlights/highlight_photography.jpg',
      },
    ];

    // Wrap instead of a fixed-height grid: each card sizes to its own text,
    // so long translations never overflow.
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 24.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                crossAxisCount;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final highlight in highlights)
              SizedBox(
                width: itemWidth,
                child: HighlightCard(
                  title: highlight['title'].toString(),
                  description: highlight['description'].toString(),
                  icon: highlight['icon'] as IconData,
                  color: highlight['color'] as Color,
                  imageUrl: highlight['image'] as String?,
                ),
              ),
          ],
        );
      },
    );
  }
}
