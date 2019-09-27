library remote_log_elastic;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:remote_log_elastic/log_model.dart';

enum RemoteLogType { DEBUG, TEST, ERROR }
enum RemoteLogEnv { DEV, TEST, HOM, PROD }

class RemoteLog {
  String _url;
  String _indexName;
  RemoteLogEnv _environment;

  RemoteLog({
    @required environment,
    @required url,
    @required indexName,
  })  : assert(url != null && url.isNotEmpty),
        assert(indexName != null && indexName.isNotEmpty) {
    this._url = url;
    this._indexName = indexName;
    this._environment = environment;
  }

  /// Return null if error
  Future<Log> debug(String log) async {
    return _log(RemoteLogType.DEBUG, log);
  }

  /// Return null if error
  Future<Log> test(String log) async {
    return _log(RemoteLogType.TEST, log);
  }

  /// Return null if error
  Future<Log> error(String log) async {
    return _log(RemoteLogType.ERROR, log);
  }

  // @TODO Save log before send and update syncedAt after send with success
  Future<Log> _log(RemoteLogType type, String text) async {
    Log logDAO = Log(
      environment: _environment,
      type: type,
      text: text,
    );

    try {
      final body = logDAO.toJson();
      final path = '$_url/$_indexName/_doc';

      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(path));

      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(body)));

      HttpClientResponse response = await request.close();

      httpClient.close();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return logDAO;
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }
}
