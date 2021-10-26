library cielo_oauth;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'src/access_token_response.dart';
import 'src/access_token_result.dart';
import 'src/environment.dart';
import 'src/error_response.dart';

export 'src/access_token_result.dart';
export 'src/environment.dart';

class OAuth {
  final String ? clientId;
  final String ? clientSecret;
  final Environment ? environment;
  String ? _url;
  String ? _base64;

  OAuth({
    required this.clientId,
    required this.clientSecret,
    this.environment = Environment.SANDBOX,
  }) {
    this._url = _defineUrl(environment!);
    this._base64 = _defineBase64(clientId!, clientSecret!);
  }

  Future<AccessTokenResult> getToken() async {
    String sdkName = 'CieloOAuth';
    String sdkVersion = '1.1.1';

    Response response = (await http.post(
      this._url,
      headers: <String, String>{
        'Authorization': 'Basic ${this._base64}',
        'x-sdk-version': '$sdkName-Dart@$sdkVersion'
      },
      body: <String, String>{'grant_type': 'client_credentials'},
    ));
    return _oAuthResult(response);
  }
}

String _defineUrl(Environment environment) {
  return environment == Environment.SANDBOX
      ? 'https://authsandbox.cieloecommerce.cielo.com.br/oauth2/token'
      : 'https://auth.braspag.com.br/oauth2/token';
}

String _defineBase64(String clientId, String clientSecret) {
  var bytes = utf8.encode("$clientId:$clientSecret");
  return base64Encode(bytes);
}

AccessTokenResult _oAuthResult(Response response) {
  return response.statusCode == 200 || response.statusCode == 201
      ? AccessTokenResult(
          accessTokenResponse:
              AccessTokenResponse.fromJson(jsonDecode(response.body)),
          statusCode: response.statusCode)
      : AccessTokenResult(
          errorResponse: ErrorResponse.fromJson(jsonDecode(response.body)),
          statusCode: response.statusCode);
}
