import 'package:flutter/foundation.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/app/setup/flavor.dart';
import 'package:flutter_app/core/analytics/crashlytics_manager.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Wrapper over the Talker package.
class Flogger {
  static const bool _providerLogsEnabled = false;

  static final talker = TalkerFlutter.init(
    logger: TalkerLogger(formatter: _LoggerFormatter()),
    settings: TalkerSettings(enabled: Configuration.instance.flavor != Flavor.production || kDebugMode), // Disable logs for Production.
  );

  static final colors = {
    'httpRequest': AnsiPen()..xterm(50),
    'httpResponse': AnsiPen()..xterm(42),
    'httpError': AnsiPen()..xterm(196),
    'providerAdded': AnsiPen()..xterm(241),
    'providerUpdated': AnsiPen()..xterm(242),
    'providerRemoved': AnsiPen()..xterm(241),
    'navigation': AnsiPen()..xterm(136),
    'verbose': AnsiPen()..xterm(242),
    'debug': AnsiPen()..xterm(46),
    'info': AnsiPen()..xterm(6),
    'warning': AnsiPen()..xterm(3),
    'error': AnsiPen()..xterm(9),
  };

  static void v(dynamic message, {Object? exception, StackTrace? stackTrace, DateTime? time}) {
    CrashlyticsManager.logMessage(message);
    talker.logCustom(
      _CustomLog(
        message.toString(),
        exception: exception,
        stackTrace: stackTrace,
        pen: colors['verbose'],
        key: 'verbose',
      ),
    );
  }

  static void d(dynamic message, {Object? exception, StackTrace? stackTrace, DateTime? time}) {
    CrashlyticsManager.logMessage(message);
    talker.logCustom(
      _CustomLog(
        message.toString(),
        exception: exception,
        stackTrace: stackTrace,
        pen: colors['debug'],
        key: 'debug',
      ),
    );
  }

  static void i(dynamic message, {Object? exception, StackTrace? stackTrace, DateTime? time}) {
    CrashlyticsManager.logMessage(message);
    talker.logCustom(
      _CustomLog(
        message.toString(),
        exception: exception,
        stackTrace: stackTrace,
        pen: colors['info'],
        key: 'info',
      ),
    );
  }

  static void w(dynamic message, {Object? exception, StackTrace? stackTrace, DateTime? time}) {
    CrashlyticsManager.logNonCritical(exception, stack: stackTrace, message: message.toString());
    talker.logCustom(
      _CustomLog(
        message.toString(),
        exception: exception,
        stackTrace: stackTrace,
        pen: colors['warning'],
        key: 'warning',
      ),
    );
  }

  static void e(dynamic message, {Object? exception, StackTrace? stackTrace, DateTime? time}) {
    CrashlyticsManager.logNonCritical(exception, stack: stackTrace, message: message.toString());
    talker.logCustom(
      _CustomLog(
        message.toString(),
        exception: exception,
        stackTrace: stackTrace,
        pen: colors['error'],
        key: 'error',
      ),
    );
  }

  static void navigation(dynamic message) => talker.logCustom(
    _CustomLog(
      message.toString(),
      pen: colors['navigation'],
      key: 'navigation',
    ),
  );

  static void providerAdded(dynamic message) => _providerLogsEnabled
      ? talker.logCustom(
          _CustomLog(
            message.toString(),
            pen: colors['providerAdded'],
            key: 'providerAdded',
          ),
        )
      : null;
  static void providerUpdated(dynamic message) => _providerLogsEnabled
      ? talker.logCustom(
          _CustomLog(
            message.toString(),
            pen: colors['providerUpdated'],
            key: 'providerUpdated',
          ),
        )
      : null;
  static void providerRemoved(dynamic message) => _providerLogsEnabled
      ? talker.logCustom(
          _CustomLog(
            message.toString(),
            pen: colors['providerRemoved'],
            key: 'providerRemoved',
          ),
        )
      : null;
}

class _CustomLog extends TalkerLog {
  _CustomLog(String super.message, {super.key, super.exception, super.stackTrace, super.pen});

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    return '$displayMessage$displayException$displayStackTrace';
  }
}

class _LoggerFormatter implements LoggerFormatter {
  final _maxOutputThreshold = 880;
  final _borderPens = [
    Flogger.colors['warning']?.fcolor,
    Flogger.colors['error']?.fcolor,
    Flogger.colors['httpError']?.fcolor,
    Flogger.colors['httpRequest']?.fcolor,
    Flogger.colors['httpResponse']?.fcolor,
  ];

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final showBorder = _borderPens.contains(details.pen.fcolor);
    final underline = ConsoleUtils.getUnderline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
      withCorner: true,
    );
    final topline = ConsoleUtils.getTopline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
      withCorner: true,
    );
    final msg = details.message?.toString() ?? '';
    final msgBorderedLines = _splitLongLines(msg, _maxOutputThreshold).split('\n').map((e) => '│ $e');
    if (!settings.enableColors) {
      return showBorder ? '$topline\n${msgBorderedLines.join('\n')}\n$underline' : msgBorderedLines.join('\n');
    }
    var lines = [if (showBorder) topline, ...msgBorderedLines, if (showBorder) underline];
    lines = lines.map((e) => details.pen.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }

  static String _splitLongLines(String input, int maxLineLength) {
    final lines = input.split('\n');
    final outputLines = <String>[];

    for (final line in lines) {
      if (line.length > maxLineLength) {
        // Split the line into chunks of maxLineLength
        for (var i = 0; i < line.length; i += maxLineLength) {
          final end = (i + maxLineLength < line.length) ? i + maxLineLength : line.length;
          outputLines.add(line.substring(i, end));
        }
      } else {
        outputLines.add(line);
      }
    }

    return outputLines.join('\n');
  }
}
