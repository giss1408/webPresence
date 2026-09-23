import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/services/analytics_service.dart';
import 'package:flutter_website/models/analytics_models.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  late final AnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _analyticsService = AnalyticsService();
  }

  @override
  Widget build(BuildContext context) {
    final summary = _analyticsService.getSummary();
    final allEvents = _analyticsService.getAllEvents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        elevation: 0,
        backgroundColor: ModernColors.backgroundCard,
        foregroundColor: ModernColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: BoxDecoration(
                gradient: ModernColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Text(
                    'Analytics Dashboard',
                    style: ModernTypography.displayLarge.copyWith(
                      color: ModernColors.textWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Real-time user interaction metrics',
                    style: ModernTypography.bodyLarge.copyWith(
                      color: ModernColors.textWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      children: [
                        _MetricCard(
                          title: 'Total Page Views',
                          value: summary.totalPageViews.toString(),
                          icon: Icons.pageview,
                          color: ModernColors.primary,
                        ),
                        _MetricCard(
                          title: 'Total Events Tracked',
                          value: summary.totalEvents.toString(),
                          icon: Icons.track_changes,
                          color: ModernColors.accentGreen,
                        ),
                        _MetricCard(
                          title: 'Unique Pages Visited',
                          value: summary.pageViewCounts.length.toString(),
                          icon: Icons.summarize,
                          color: ModernColors.accentPurple,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Top Pages
                    const Text(
                      'Top Pages',
                      style: ModernTypography.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    _PageStatsWidget(pageViewCounts: summary.pageViewCounts),

                    const SizedBox(height: 40),

                    // Top Events
                    const Text(
                      'Top Events',
                      style: ModernTypography.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    _EventStatsWidget(eventCounts: summary.eventCounts),

                    const SizedBox(height: 40),

                    // Recent Events
                    const Text(
                      'Recent Events',
                      style: ModernTypography.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    _RecentEventsWidget(events: allEvents.reversed.toList()),

                    const SizedBox(height: 40),

                    // Action Buttons
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _showExportDialog(context, summary);
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Export Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ModernColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            _showClearDialog(context);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Clear Data'),
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

  void _showExportDialog(BuildContext context, AnalyticsSummary summary) {
    final json = _analyticsService.exportAsJson();
    final jsonString = _prettyPrintJson(json);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Analytics Data'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              jsonString,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Analytics Data'),
        content: const Text(
          'Are you sure you want to clear all analytics data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _analyticsService.clearData();
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ModernColors.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  String _prettyPrintJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ModernColors.backgroundCard,
        borderRadius: BorderRadius.circular(ModernRadius.lg),
        border: Border.all(color: ModernColors.border),
        boxShadow: ModernShadows.elevation2,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 16),
          Text(
            value,
            style: ModernTypography.displaySmall.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: ModernTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageStatsWidget extends StatelessWidget {
  final Map<String, int> pageViewCounts;

  const _PageStatsWidget({required this.pageViewCounts});

  @override
  Widget build(BuildContext context) {
    if (pageViewCounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ModernColors.backgroundHover,
          borderRadius: BorderRadius.circular(ModernRadius.md),
        ),
        child: const Text('No page views recorded'),
      );
    }

    final sorted = pageViewCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: List.generate(
        sorted.length,
        (index) => _StatRow(
          label: sorted[index].key,
          value: sorted[index].value.toString(),
          index: index + 1,
        ),
      ),
    );
  }
}

class _EventStatsWidget extends StatelessWidget {
  final Map<String, int> eventCounts;

  const _EventStatsWidget({required this.eventCounts});

  @override
  Widget build(BuildContext context) {
    if (eventCounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ModernColors.backgroundHover,
          borderRadius: BorderRadius.circular(ModernRadius.md),
        ),
        child: const Text('No events tracked'),
      );
    }

    final sorted = eventCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: List.generate(
        sorted.length,
        (index) => _StatRow(
          label: sorted[index].key,
          value: sorted[index].value.toString(),
          index: index + 1,
        ),
      ),
    );
  }
}

class _RecentEventsWidget extends StatelessWidget {
  final List<AnalyticsEvent> events;

  const _RecentEventsWidget({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ModernColors.backgroundHover,
          borderRadius: BorderRadius.circular(ModernRadius.md),
        ),
        child: const Text('No recent events'),
      );
    }

    return Column(
      children: events.take(10).map((event) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ModernColors.backgroundCard,
            borderRadius: BorderRadius.circular(ModernRadius.md),
            border: Border.all(color: ModernColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.name,
                    style: ModernTypography.titleMedium,
                  ),
                  Text(
                    _formatTime(event.timestamp),
                    style: ModernTypography.bodySmall.copyWith(
                      color: ModernColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Page: ${event.pageContext}',
                style: ModernTypography.bodySmall.copyWith(
                  color: ModernColors.textSecondary,
                ),
              ),
              if (event.parameters.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Parameters: ${event.parameters}',
                  style: ModernTypography.bodySmall.copyWith(
                    color: ModernColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final int index;

  const _StatRow({
    required this.label,
    required this.value,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ModernColors.backgroundCard,
        borderRadius: BorderRadius.circular(ModernRadius.md),
        border: Border.all(color: ModernColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ModernColors.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    index.toString(),
                    style: ModernTypography.labelMedium.copyWith(
                      color: ModernColors.textWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: ModernTypography.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: ModernTypography.titleMedium.copyWith(
              color: ModernColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class JsonEncoder {
  final String indent;

  const JsonEncoder.withIndent(this.indent);

  String convert(Object? object) {
    final buffer = StringBuffer();
    _write(object, buffer, 0);
    return buffer.toString();
  }

  void _write(Object? object, StringBuffer buffer, int depth) {
    if (object == null) {
      buffer.write('null');
    } else if (object is String) {
      buffer.write('"${object.replaceAll('"', '\\"')}"');
    } else if (object is num || object is bool) {
      buffer.write(object);
    } else if (object is Map) {
      buffer.write('{\n');
      final entries = object.entries.toList();
      for (int i = 0; i < entries.length; i++) {
        buffer.write(indent * (depth + 1));
        buffer.write('"${entries[i].key}": ');
        _write(entries[i].value, buffer, depth + 1);
        if (i < entries.length - 1) buffer.write(',');
        buffer.write('\n');
      }
      buffer.write('${indent * depth}}');
    } else if (object is List) {
      buffer.write('[\n');
      for (int i = 0; i < object.length; i++) {
        buffer.write(indent * (depth + 1));
        _write(object[i], buffer, depth + 1);
        if (i < object.length - 1) buffer.write(',');
        buffer.write('\n');
      }
      buffer.write('${indent * depth}]');
    } else {
      buffer.write(object);
    }
  }
}
