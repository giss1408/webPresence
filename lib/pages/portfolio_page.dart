import 'package:flutter/material.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/showcase/app_showcase.dart';
import 'package:flutter_website/ui/showcase/demo_screens.dart';
import 'package:flutter_website/ui/showcase/screen_recording.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  // To add a screen recording to a project, put the MP4 in assets/videos/,
  // list that folder under `assets:` in pubspec.yaml and set `recording`.
  static const List<_ProjectCardData> _projects = [
    _ProjectCardData(
      title: 'portfolio.tourism_title',
      subtitle: 'portfolio.tourism_subtitle',
      description: 'portfolio.tourism_desc',
      tags: ['Flutter', 'Django', 'GraphQL', 'Stripe'],
      icon: Icons.travel_explore,
      accent: Color(0xFFF77F00),
      demo: DemoApp.akwaba,
      recording: null, // e.g. 'assets/videos/akwaba.mp4'
    ),
    _ProjectCardData(
      title: 'portfolio.djassa_title',
      subtitle: 'portfolio.djassa_subtitle',
      description: 'portfolio.djassa_desc',
      tags: ['Flutter', 'FastAPI', 'Offline-first'],
      icon: Icons.storefront,
      accent: Color(0xFFD1571E),
      demo: DemoApp.djassa,
      recording: null,
    ),
    _ProjectCardData(
      title: 'portfolio.djassa_title',
      subtitle: 'portfolio.djassa_user_subtitle',
      description: 'portfolio.djassa_user_desc',
      tags: ['Flutter', 'Riverpod', 'Mobile Money', 'QR'],
      icon: Icons.local_pharmacy,
      accent: Color(0xFFC94A22),
      demo: DemoApp.djassaUser,
      recording: null,
    ),
    _ProjectCardData(
      title: 'portfolio.immoizi_title',
      subtitle: 'portfolio.immoizi_subtitle',
      description: 'portfolio.immoizi_desc',
      tags: ['Flutter', 'Django', 'GraphQL'],
      icon: Icons.apartment,
      accent: Color(0xFF6272A4),
      demo: DemoApp.immoizi,
      recording: null,
    ),
  ];

  /// App shown in the live demo; the cards' "Try the demo" buttons set it.
  final _demo = ValueNotifier(DemoApp.akwaba);
  final _demoKey = GlobalKey();

  @override
  void dispose() {
    _demo.dispose();
    super.dispose();
  }

  void _tryDemo(DemoApp app) {
    _demo.value = app;
    final target = _demoKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

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
                  AppShowcase(
                    key: _demoKey,
                    selection: _demo,
                    showPortfolioLink: false,
                  ),
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
                                    ? _ProjectCard(
                                        project: _projects[j],
                                        onTryDemo: () =>
                                            _tryDemo(_projects[j].demo),
                                      )
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
  const _ProjectCard({required this.project, required this.onTryDemo});

  final _ProjectCardData project;
  final VoidCallback onTryDemo;

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
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onTryDemo,
                  icon: const Icon(Icons.phone_iphone, size: 18),
                  label: Text(tr('portfolio.try_demo')),
                ),
                if (project.recording != null)
                  OutlinedButton.icon(
                    onPressed: () =>
                        showScreenRecording(context, asset: project.recording!),
                    icon: const Icon(Icons.play_circle_outline, size: 18),
                    label: Text(tr('portfolio.watch')),
                  ),
              ],
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
    required this.demo,
    required this.recording,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final IconData icon;
  final Color accent;
  final DemoApp demo;

  /// Screen recording asset (MP4), shown in a phone when present.
  final String? recording;
}
