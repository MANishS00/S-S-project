import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;

  LoggingHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  String _prettyJson(dynamic jsonObject) {
    try {
      var encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(jsonObject);
    } catch (_) {
      return jsonObject.toString();
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    final reqId = startTime.millisecondsSinceEpoch.toString().substring(7);

    String reqBodyText = '';
    if (request is http.Request) {
      reqBodyText = request.body;
    }

    String formattedReqBody = reqBodyText;
    if (reqBodyText.isNotEmpty) {
      try {
        final decoded = json.decode(reqBodyText);
        formattedReqBody = _prettyJson(decoded);
      } catch (_) {}
    }

    final StringBuffer logBuffer = StringBuffer();
    logBuffer.writeln(
        '-------------------- 🚀 API REQUEST [$reqId] --------------------');
    logBuffer.writeln('URL     : ${request.method} ${request.url}');
    if (request.headers.isNotEmpty) {
      logBuffer.writeln('HEADERS : ${jsonEncode(request.headers)}');
    }
    if (formattedReqBody.isNotEmpty) {
      logBuffer.writeln('BODY    :\n$formattedReqBody');
    }
    logBuffer.writeln(
        '------------------------------------------------------------------');
    debugPrint(logBuffer.toString());

    try {
      final streamedResponse = await _inner.send(request);
      final bytes = await streamedResponse.stream.toBytes();
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final responseBody = utf8.decode(bytes, allowMalformed: true);

      String formattedResBody = responseBody;
      if (responseBody.isNotEmpty) {
        try {
          final decoded = json.decode(responseBody);
          formattedResBody = _prettyJson(decoded);
        } catch (_) {}
      }

      final StringBuffer resBuffer = StringBuffer();
      resBuffer.writeln(
          '-------------------- 📥 API RESPONSE [$reqId] (${duration}ms) --------------------');
      resBuffer.writeln('URL    : ${request.method} ${request.url}');
      resBuffer.writeln(
          'STATUS : ${streamedResponse.statusCode} ${streamedResponse.reasonPhrase ?? ""}');
      if (formattedResBody.isNotEmpty) {
        resBuffer.writeln('BODY   :\n$formattedResBody');
      }
      resBuffer.writeln(
          '-------------------------------------------------------------------------');
      debugPrint(resBuffer.toString());

      return http.StreamedResponse(
        http.ByteStream.fromBytes(bytes),
        streamedResponse.statusCode,
        contentLength: streamedResponse.contentLength,
        request: streamedResponse.request,
        headers: streamedResponse.headers,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
        reasonPhrase: streamedResponse.reasonPhrase,
      );
    } catch (error) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final StringBuffer errBuffer = StringBuffer();
      errBuffer.writeln(
          '-------------------- ❌ API ERROR [$reqId] (${duration}ms) --------------------');
      errBuffer.writeln('URL   : ${request.method} ${request.url}');
      errBuffer.writeln('ERROR : $error');
      errBuffer.writeln(
          '-----------------------------------------------------------------------');
      debugPrint(errBuffer.toString());
      rethrow;
    }
  }
}
