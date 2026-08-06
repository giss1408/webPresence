import 'package:flutter/material.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  static const List<_ProjectCardData> _projects = [
    _ProjectCardData(
      title: 'Plateforme SaaS B2B',
      subtitle: 'Automatisation & analytics',
      description:
          'Tableau de bord multi-tenant avec workflows d’automatisation et reporting temps réel.',
      tags: ['Flutter', 'Firebase', 'SaaS'],
      accent: Color(0xFF1E88E5),
    ),
    _ProjectCardData(
      title: 'Marketplace urbain',
      subtitle: 'Expérience mobile premium',
      description:
          'Application de réservation et gestion de services locale pensée pour une adoption rapide.',
      tags: ['UI/UX', 'Mobile', 'Growth'],
      accent: Color(0xFF43A047),
    ),
    _ProjectCardData(
      title: 'Portail institutionnel',
      subtitle: 'Communication & services',
      description:
          'Refonte complète d’un portail public avec parcours guidés et contenus personnalisés.',
      tags: ['Web', 'Design System', 'CMS'],
      accent: Color(0xFFFB8C00),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réalisations'),
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
                    'Nos réalisations',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quelques exemples de projets conçus pour des équipes ambitieuses.',
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
                                project.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                project.subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: project.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                project.description,
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
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(999),
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
