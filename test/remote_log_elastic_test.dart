import 'package:flutter_test/flutter_test.dart';
import 'package:remote_log_elastic/log_model.dart';
import 'package:remote_log_elastic/remote_log_elastic.dart';

void main() {
  RemoteLog remoteLog;

  setUpAll(() {
    remoteLog = RemoteLog(
      environment: RemoteLogEnv.TEST,
      url: 'URL_ELASTIC',
      indexName: 'INDEX_NAME',
    );
  });

  test('Create remote debug log', () async {
    final Log log = await remoteLog.debug("Olá debug log, tudo bem?");

    expect(log, isNotNull);
    expect(log.type, RemoteLogType.DEBUG);
    expect(log.isSync(), isTrue);
  });

  test('Create remote Error log', () async {
    final Log log = await remoteLog.error("Olá error log, tudo bem?");

    expect(log, isNotNull);
    expect(log.type, RemoteLogType.ERROR);
    expect(log.isSync(), isTrue);
  });
}
