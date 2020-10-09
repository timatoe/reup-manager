import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:reup_manager/utils/platform_aware_secure_storage.dart';
import 'package:reup_manager/utils/simple_bloc_observer.dart';
import 'package:universal_html/html.dart' show window;

import 'app.dart';
import 'data/authentication_repository.dart';
import 'data/remote/auth_api_client.dart';
import 'data/remote/user_api_client.dart';
import 'data/user_repository.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final mobileSecureStorage = FlutterSecureStorage();
  
  final secureStorage = PlatformAwareSecureStorage(
    mobileSecureStorage, 
    window.localStorage
  );

  runApp(App(
    authenticationRepository: AuthenticationRepository(
      AuthApiClient(httpClient: http.Client()),
      secureStorage,
    ),
    userRepository: UserRepository(
        UserApiClient(httpClient: http.Client(), secureStorage: secureStorage)),
  ));
}
