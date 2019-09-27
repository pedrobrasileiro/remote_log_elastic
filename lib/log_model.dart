import 'package:flutter/foundation.dart';
import 'package:remote_log_elastic/remote_log_elastic.dart';

enum LogField { CREATED_AT, SYNC_AT }

class Log {
  /// Timestamp UTC
  int _createdAt;

  /// Timestamp UTC
  int _syncedAt;

  /// Object to save. JSON Format
  String text;

  RemoteLogType type;
  RemoteLogEnv environment;

  /// Get created at timestamp, in UTC
  int get createdAt => _createdAt;

  /// Get synced at timestamp, in UTC
  int get syncedAt => _syncedAt;

  Log({
    @required this.environment,
    @required this.type,
    @required this.text,
  })  : assert(type is RemoteLogType),
        assert(environment is RemoteLogEnv) {
    touch(LogField.CREATED_AT);
  }

  String toString() {
    return 'ENV: ${_environmentToString()} ${_typeToString()}: $createdAt => $text';
  }

  String _typeToString() {
    return type == RemoteLogType.ERROR
        ? "ERROR"
        : type == RemoteLogType.TEST ? "TEST" : "DEBUG";
  }

  String _environmentToString() {
    return environment == RemoteLogEnv.DEV
        ? "DEV"
        : environment == RemoteLogEnv.TEST
            ? "TEST"
            : environment == RemoteLogEnv.HOM ? "HOM" : "PROD";
  }

  dynamic toJson() {
    touch(LogField.SYNC_AT);

    return {
      "environment": _environmentToString(),
      "type": _typeToString(),
      "text": text,
      "createdAt": "$_createdAt",
      "syncedAt": "$_syncedAt"
    };
  }

  bool isSync() {
    return _syncedAt != null && _syncedAt > 0;
  }

  void touch(LogField field) {
    switch (field) {
      case LogField.CREATED_AT:
        _createdAt = new DateTime.now().millisecondsSinceEpoch;
        break;
      case LogField.SYNC_AT:
        _syncedAt = new DateTime.now().millisecondsSinceEpoch;
        break;
    }
  }
}
