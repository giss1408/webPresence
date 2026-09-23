import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global error handler for production-ready error management
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();

  factory ErrorHandler() {
    return _instance;
  }

  ErrorHandler._internal();

  final Logger _logger = Logger(printer: SimplePrinter(printTime: true));

  /// Handle and log errors
  void handleError(
    dynamic error, {
    required String context,
    StackTrace? stackTrace,
    VoidCallback? onRetry,
  }) {
    _logger.e('Error in $context: $error', stackTrace: stackTrace);
  }

  /// Handle network errors
  void handleNetworkError(dynamic error, {String? context}) {
    _logger.e('Network error${context != null ? ' in $context' : ''}: $error');
  }

  /// Installs handlers for framework and uncaught async errors.
  ///
  /// Debug builds keep Flutter's own detailed report (with the widget that
  /// caused it); release builds log a single line to the browser console
  /// instead of failing silently. Hook a crash reporter in [_report].
  static void setupGlobalErrorHandler() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        _report(details.exception, details.stack);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _report(error, stack);
      return true;
    };
  }

  static void _report(Object error, StackTrace? stack) {
    debugPrint('Uncaught error: $error');
    if (kDebugMode && stack != null) debugPrintStack(stackTrace: stack);
  }
}
