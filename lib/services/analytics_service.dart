import 'package:logger/logger.dart';
import 'package:flutter_website/models/analytics_models.dart';

/// Analytics service for tracking user interactions and performance metrics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  final Logger _logger = Logger();

  // Analytics storage
  final List<AnalyticsEvent> _events = [];
  final List<PageViewEvent> _pageViews = [];
  String _currentPage = 'unknown';

  /// Track page view
  void trackPageView(String pageName) {
    _currentPage = pageName;
    final pageView = PageViewEvent(
      pageName: pageName,
      viewedAt: DateTime.now(),
    );
    _pageViews.add(pageView);
    _logger.i('📍 Page viewed: $pageName (Total: ${_pageViews.length})');
  }

  /// Track user interaction
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    final event = AnalyticsEvent(
      name: eventName,
      timestamp: DateTime.now(),
      parameters: parameters ?? {},
      pageContext: _currentPage,
    );
    _events.add(event);
    _logger.i('🎯 Event: $eventName - ${parameters.toString()}');
  }

  /// Track custom exception
  void trackException(dynamic exception, {dynamic stackTrace}) {
    trackEvent('exception_thrown', parameters: {
      'error': exception.toString(),
      'type': exception.runtimeType.toString(),
    });
    _logger.e('❌ Exception tracked: $exception',
        error: exception, stackTrace: stackTrace);
  }

  /// Track performance metric
  void trackPerformance(String metricName, Duration duration) {
    trackEvent('performance_metric', parameters: {
      'metric': metricName,
      'duration_ms': duration.inMilliseconds,
    });
    _logger.i('⚡ Performance - $metricName: ${duration.inMilliseconds}ms');
  }

  /// Set user properties
  void setUserProperties({
    required String userId,
    Map<String, String>? customProperties,
  }) {
    final props = {'userId': userId, ...?customProperties};
    trackEvent('user_properties_set', parameters: props);
    _logger.i('👤 User properties set: ${props.toString()}');
  }

  /// Get analytics summary for dashboard
  AnalyticsSummary getSummary() {
    final pageViewCounts = <String, int>{};
    final eventCounts = <String, int>{};

    for (var pv in _pageViews) {
      pageViewCounts[pv.pageName] = (pageViewCounts[pv.pageName] ?? 0) + 1;
    }

    for (var event in _events) {
      eventCounts[event.name] = (eventCounts[event.name] ?? 0) + 1;
    }

    final topPages = pageViewCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEvents = eventCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return AnalyticsSummary(
      totalPageViews: _pageViews.length,
      totalEvents: _events.length,
      topPages: topPages.map((e) => e.key).toList(),
      topEvents: topEvents.map((e) => e.key).toList(),
      generatedAt: DateTime.now(),
      pageViewCounts: pageViewCounts,
      eventCounts: eventCounts,
    );
  }

  /// Get all events
  List<AnalyticsEvent> getAllEvents() => List.unmodifiable(_events);

  /// Get all page views
  List<PageViewEvent> getAllPageViews() => List.unmodifiable(_pageViews);

  /// Clear analytics data
  void clearData() {
    _events.clear();
    _pageViews.clear();
    _logger.i('🗑️ Analytics data cleared');
  }

  /// Export analytics as JSON
  Map<String, dynamic> exportAsJson() {
    return {
      'generated_at': DateTime.now().toIso8601String(),
      'total_page_views': _pageViews.length,
      'total_events': _events.length,
      'page_views': _pageViews
          .map((pv) => {
                'page': pv.pageName,
                'viewed_at': pv.viewedAt.toIso8601String(),
                'duration_seconds': pv.duration?.inSeconds,
              })
          .toList(),
      'events': _events
          .map((e) => {
                'name': e.name,
                'timestamp': e.timestamp.toIso8601String(),
                'page_context': e.pageContext,
                'parameters': e.parameters,
              })
          .toList(),
    };
  }
}
