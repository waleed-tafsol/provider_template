import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample_app/app_init.dart';
import 'package:provider_sample_app/domain/repositories/auth_repository.dart';
import 'package:provider_sample_app/domain/use_cases/sign_in_use_case.dart';
import 'package:provider_sample_app/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:provider_sample_app/data/network/api_client.dart';
import 'package:provider_sample_app/data/repositories/auth_repository_impl.dart';
import 'package:provider_sample_app/presentation/view_models/auth_view_model.dart';
import 'package:provider_sample_app/core/storage/shared_pref.dart';
import 'package:provider_sample_app/presentation/view_models/theme_view_model.dart';

import 'core/storage/secure_storage_service.dart';
import 'core/logging/logger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  AppLogger.init();
  AppLogger.i('🚀 App starting...');
  
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPref.init();

  // Initialize dependencies - Clean Architecture
  final secureStorage = SecureStorage();
  await secureStorage.init();
  
  // Data Layer
  final apiClient = ApiClient(secureStorage: secureStorage);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    apiClient: apiClient,
    secureStorage: secureStorage,
  );
  
  // Domain Layer - Repository
  final AuthRepository authRepository = AuthRepositoryImpl(
    authRemoteDataSource,
  );
  
  // Domain Layer - Use Cases
  final signInUseCase = SignInUseCase(authRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(signInUseCase: signInUseCase),
        ),
      ],
      child: const AppInit(),
    ),
  );
}
