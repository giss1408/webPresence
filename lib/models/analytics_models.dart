/// Analytics event model for tracking and dashboard display
class AnalyticsEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> parameters;
  final String pageContext;

  AnalyticsEvent({
    required this.name,
    required this.timestamp,
    required this.parameters,
    required this.pageContext,
  });

  @override
  String toString() =>
      'AnalyticsEvent(name: $name, time: $timestamp, page: $pageContext, params: $parameters)';
}

/// Page view tracking model
class PageViewEvent {
  final String pageName;
  final DateTime viewedAt;
  final Duration? duration;

  PageViewEvent({
    required this.pageName,
    required this.viewedAt,
    this.duration,
  });

  @override
  String toString() =>
      'PageViewEvent(page: $pageName, viewed: $viewedAt, duration: ${duration?.inSeconds}s)';
}

/// Analytics summary for dashboard
class AnalyticsSummary {
  final int totalPageViews;
  final int totalEvents;
  final List<String> topPages;
  final List<String> topEvents;
  final DateTime generatedAt;
  final Map<String, int> pageViewCounts;
  final Map<String, int> eventCounts;

  AnalyticsSummary({
    required this.totalPageViews,
    required this.totalEvents,
    required this.topPages,
    required this.topEvents,
    required this.generatedAt,
    required this.pageViewCounts,
    required this.eventCounts,
  });

  /// Get the most viewed page
  String get mostViewedPage => topPages.isNotEmpty ? topPages.first : 'N/A';

  /// Get the most triggered event
  String get mostTriggeredEvent =>
      topEvents.isNotEmpty ? topEvents.first : 'N/A';

  /// Get average page views
  double get averagePageViewsPerPage =>
      totalPageViews > 0 ? totalPageViews / pageViewCounts.length : 0;
}
