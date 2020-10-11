import 'dart:io';

import 'package:reup_manager/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class AuthApiClient {
  static const authBaseUrl = "$baseUrl/auth";
  final http.Client httpClient;

  AuthApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<String> logIn(
    String email,
    String password,
  ) async {
    final loginUrl = '$authBaseUrl/login';
    var loginResponse = await this
        .httpClient
        .post(loginUrl, body: {"email": email, "password": password});
    if (loginResponse.statusCode != HttpStatus.ok) {
      throw Exception('error logging in');
    }
    return loginResponse.body;
  }

  Future<String> signUp(
      String email, String displayName, String password) async {
    final signUpUrl = '$authBaseUrl/create';
    var signUpResponse = await this.httpClient.post(signUpUrl, body: {
      "email": email,
      "displayName": displayName,
      "password": password,
    });
    if (signUpResponse.statusCode != HttpStatus.created) {
      throw Exception('error creating account');
    }
    return signUpResponse.body;
  }
}
