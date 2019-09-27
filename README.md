# remote_log_elastic

- Save flutter logs in ElasticSearch

```dart
final remoteLog = RemoteLog(
  environment: RemoteLogEnv.TEST,
  url: URL_ELASTIC,
  indexName: INDEX_NAME,
);
```

- DEBUG
```dart
remoteLog.debug('Hello debug log!!!!');
```

- ERROR
```dart
remoteLog.error('Hello error log!!!!');
```

Log saved in ElasticSearch

```json
{
  "_source" : {
    "environment" : "TEST",
    "type" : "ERROR",
    "text" : "Olá error log, tudo bem?",
    "createdAt" : "1569614645246",
    "syncedAt" : "1569614645246"
  }
}
```
