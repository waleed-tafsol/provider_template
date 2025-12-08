//final themeProvider = ChangeNotifierProvider((_) => ThemeNotifier());

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider_sample_app/route_generator.dart';
import 'package:provider_sample_app/utils/screen_size.dart';
import 'package:provider_sample_app/utils/theme.dart';
import 'package:provider_sample_app/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = context.watch<ThemeViewModel>().themeMode;
    return ScreenUtilInit(
      designSize: getDesignSize(context: context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Provider Sample App',
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
