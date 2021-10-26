library cielo_zero_auth;

import 'dart:convert';

import 'package:pay_cielo_demostracaoapp/libCieloEcommerce/cielo_oauth.dart' as oauth;
import 'package:http/http.dart' as http;

import 'src/environment.dart';
import 'src/zero_auth_error_response.dart';
import 'src/zero_auth_request.dart';
import 'src/zero_auth_response.dart';
import 'src/zero_auth_result.dart';

export 'src/environment.dart';
export 'src/zero_auth_error_response.dart';
export 'src/zero_auth_request.dart';
export 'src/zero_auth_response.dart';
export 'src/zero_auth_result.dart';

class CieloZeroAuth {
  final String ? clientId;
  final String ? clientSecret;
  final String ? merchantId;
  final Environment ? environment;
  oauth.Environment ? _oAuthEnvironment;
  String ? _url;

  CieloZeroAuth({
    required this.clientId,
    required this.clientSecret,
    required this.merchantId,
    this.environment = Environment.SANDBOX
  }) {
    this._url = defineUrl(environment!);
    this._oAuthEnvironment = _defineOAuthEnvironment(environment!);
  }

  Future<ZeroAuthResult> validate(ZeroAuthRequest request) async {
    final accessTokenResult =
        await _getOAuthResult(clientId!, clientSecret!, _oAuthEnvironment!);

    var errorsResult = _checkOAuthErrors(accessTokenResult);
    if (errorsResult != null) return errorsResult;

    final token = accessTokenResult.accessTokenResponse?.accessToken;
    final Uri url = Uri.https(this._url!, "/1/zeroauth");

    final String sdkName = "CieloZeroAuth";
    final String sdkVersion = "1.0.4";

    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'MerchantId': this.merchantId!,
        'x-sdk-version': '$sdkName-Dart@$sdkVersion',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(request),
    );
    return _checkResponse(response);
  }
}

String defineUrl(Environment environment) {
  return environment == Environment.SANDBOX
      ? 'apisandbox.cieloecommerce.cielo.com.br'
      : 'api.cieloecommerce.cielo.com.br';
}

oauth.Environment _defineOAuthEnvironment(Environment environment) {
  return environment == Environment.SANDBOX
      ? oauth.Environment.SANDBOX
      : oauth.Environment.PRODUCTION;
}

Future<oauth.AccessTokenResult> _getOAuthResult(String clientId,
    String clientSecret, oauth.Environment _oAuthEnvironment) async {
  var oauthClient = oauth.OAuth(
    clientId: clientId,
    clientSecret: clientSecret,
    environment: _oAuthEnvironment,
  );

  return await oauthClient.getToken();
}

dynamic _checkOAuthErrors(oauth.AccessTokenResult accessTokenResult) {

  if (accessTokenResult.errorResponse != null) {

    return ZeroAuthResult(
      zeroAuthErrorResponse: <ZeroAuthErrorResponse>[
        ZeroAuthErrorResponse(
            code: accessTokenResult.errorResponse?.error,
            message: accessTokenResult.errorResponse?.errorDescription),
      ],
      statusCode: accessTokenResult.statusCode,
    );

  }

  if (accessTokenResult.accessTokenResponse?.accessToken == null) {
    return ZeroAuthResult(
      zeroAuthErrorResponse: <ZeroAuthErrorResponse>[
        ZeroAuthErrorResponse(
            code: "unknown_authentication_error",
            message: "Unknown Authentication Error")
      ],
      statusCode: accessTokenResult.statusCode,
    );
  }
}

ZeroAuthResult _checkResponse(http.Response response) {

  if (response.statusCode == 200) {
    return ZeroAuthResult(
      zeroAuthResponse: ZeroAuthResponse.fromJson(jsonDecode(response.body)),
      statusCode: response.statusCode,
    );
  } else {
    List<ZeroAuthErrorResponse> errors = <ZeroAuthErrorResponse>[];
    try {
      var jsonDecoded = jsonDecode(response.body);
      if (jsonDecoded is List) {
        errors = jsonDecoded
            .map((error) => ZeroAuthErrorResponse.fromJson(error))
            .toList();
      } else {
        errors.add(ZeroAuthErrorResponse.fromJson(jsonDecoded));
      }
      return ZeroAuthResult(
        zeroAuthErrorResponse: errors,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ZeroAuthResult(
        zeroAuthErrorResponse: <ZeroAuthErrorResponse>[
          ZeroAuthErrorResponse(
            code: response.reasonPhrase ?? "unknown_error", //removi .toLowerCase().replaceAll(" ", "_")
            message: response.reasonPhrase ?? "Unknown Error",
          )
        ],
        statusCode: response.statusCode,
      );
    }
  }

}
