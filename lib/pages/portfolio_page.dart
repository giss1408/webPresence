import 'package:flutter/material.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  static const List<_ProjectCardData> _projects = [
    _ProjectCardData(
      title: 'portfolio.tourism_title',
      subtitle: 'portfolio.tourism_subtitle',
      description: 'portfolio.tourism_desc',
      tags: ['Flutter', 'Django', 'GraphQL', 'Stripe'],
      icon: Icons.travel_explore,
      accent: Color(0xFF1E88E5),
    ),
    _ProjectCardData(
      title: 'portfolio.djassa_title',
      subtitle: 'portfolio.djassa_subtitle',
      description: 'portfolio.djassa_desc',
      tags: ['Flutter', 'FastAPI', 'Offline-first'],
      icon: Icons.storefront,
      accent: Color(0xFF43A047),
    ),
    _ProjectCardData(
      title: 'portfolio.immoizi_title',
      subtitle: 'portfolio.immoizi_subtitle',
      description: 'portfolio.immoizi_desc',
      tags: ['Flutter', 'Django', 'GraphQL'],
      icon: Icons.apartment,
      accent: Color(0xFFFB8C00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = context.watch<LocaleProvider>().tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('menu.portfolio')),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1100
                ? 3
                : constraints.maxWidth > 700
                    ? 2
                    : 1;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('portfolio.heading'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('portfolio.subtitle'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (var i = 0; i < _projects.length; i += crossAxisCount)
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
                      // Cards in a row share the tallest card's height.
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var j = i; j < i + crossAxisCount; j++) ...[
                              if (j > i) const SizedBox(width: 16),
                              Expanded(
                                child: j < _projects.length
                                    ? _ProjectCard(project: _projects[j])
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final _ProjectCardData project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = context.watch<LocaleProvider>().tr;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: project.accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                project.icon,
                color: project.accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr(project.title),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tr(project.subtitle),
              style: theme.textTheme.bodySmall?.copyWith(
                color: project.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr(project.description),
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            // Pushes the tags to the bottom when a row neighbour is taller.
            const Spacer(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: project.accent.withOpacity(0.10),
                        border: Border.all(
                          color: project.accent.withOpacity(0.35),
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: project.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCardData {
  const _ProjectCardData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final IconData icon;
  final Color accent;
}
