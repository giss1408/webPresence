/// Environment configuration for the app
/// Supports dev, staging, and production environments
enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  /// Selected at build time: `flutter build web --dart-define=APP_ENV=staging`.
  static const String environmentName =
      String.fromEnvironment('APP_ENV', defaultValue: 'production');

  static const Environment _currentEnvironment =
      environmentName == 'development'
          ? Environment.development
          : environmentName == 'staging'
              ? Environment.staging
              : Environment.production;

  /// Check if running in production
  static bool get isProduction => _currentEnvironment == Environment.production;

  /// Check if running in development
  static bool get isDevelopment =>
      _currentEnvironment == Environment.development;

  /// Check if running in staging
  static bool get isStaging => _currentEnvironment == Environment.staging;

  /// Enable analytics in production and staging
  static bool get enableAnalytics => !isDevelopment;

  /// Enable error tracking in all environments
  static bool get enableErrorTracking => true;

  /// Enable detailed logging only in development
  static bool get enableDetailedLogging => isDevelopment;

  /// App version
  static const String appVersion = '2.1.0';

  /// Build number
  static const String buildNumber = '1';

  /// Feature flags for A/B testing and gradual rollouts
  static Map<String, bool> get featureFlags => {
        'darkModeEnabled': true,
        'smoothScrollEnabled': true,
        'lazyLoadingEnabled': true,
        'advancedAnalyticsEnabled': !isDevelopment,
        'performanceMonitoringEnabled': !isDevelopment,
      };

  /// Business info
  static const String companyName = 'Regisse - Mobile Business Technologies';
  static const String companyEmail = 'info@milikey-energy.com';
  static const String companyWebsite = 'https://mobile-technologies.milikey-energy.com';
}
