import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample_app/app_init.dart';
import 'package:provider_sample_app/services/api_base_helper.dart';
import 'package:provider_sample_app/services/auth_service.dart';
import 'package:provider_sample_app/utils/shared_pref.dart';
import 'package:provider_sample_app/view_models/auth_view_model.dart';
import 'package:provider_sample_app/view_models/theme_view_model.dart';

import 'utils/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([GoogleFonts.montserratTextTheme()]);
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPref.init();

  // Initialize dependencies
  await SecureStorage().init();
  final apiBaseHelper = ApiBaseHelper();
  final authService = AuthService(
    apiClient: apiBaseHelper,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(authRepository: authService),
        ),
      ],
      child: const AppInit(),
    ),
  );
}
