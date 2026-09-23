import 'package:flutter/material.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  static const List<_ProjectCardData> _projects = [
    _ProjectCardData(
      title: 'portfolio.p1_title',
      subtitle: 'portfolio.p1_subtitle',
      description: 'portfolio.p1_desc',
      tags: ['Flutter', 'Firebase', 'SaaS'],
      accent: Color(0xFF1E88E5),
    ),
    _ProjectCardData(
      title: 'portfolio.p2_title',
      subtitle: 'portfolio.p2_subtitle',
      description: 'portfolio.p2_desc',
      tags: ['UI/UX', 'Mobile', 'Growth'],
      accent: Color(0xFF43A047),
    ),
    _ProjectCardData(
      title: 'portfolio.p3_title',
      subtitle: 'portfolio.p3_subtitle',
      description: 'portfolio.p3_desc',
      tags: ['Web', 'Design System', 'CMS'],
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final project = _projects[index];
                      return Card(
                        elevation: 0,
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
                                  Icons.auto_awesome,
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
                                          color: theme.colorScheme
                                              .surfaceContainerHighest,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          tag,
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

class _ProjectCardData {
  const _ProjectCardData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final Color accent;
}
