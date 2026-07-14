import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constant/app_texts.dart';
import 'core/connectivity/connectivity_cubit.dart';
import 'core/di/inject.dart' as di;
import 'core/localization/app_language.dart';
import 'core/localization/language_cubit.dart';
import 'core/network/dio_client.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/app_connectivity_gate.dart';

// Global navigator key for showing dialogs from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set full screen mode
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  await di.init();

  final storageService = di.sl<StorageService>();
  final dioClient = di.sl<DioClient>();
  final token = storageService.getToken();
  if (token != null) {
    dioClient.setAuthToken(token);
  }

  // Start global connectivity monitoring once.
  unawaited(di.sl<ConnectivityCubit>().start());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        final languageCubit = di.sl<LanguageCubit>();
        final connectivityCubit = di.sl<ConnectivityCubit>();
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: languageCubit),
            BlocProvider.value(value: connectivityCubit),
          ],
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              AppTexts.updateLocale(locale);
              final supportedLocales = AppLanguage.values
                  .map((lang) => lang.locale)
                  .toList(growable: false);

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  title: 'EFreeze',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  locale: locale,
                  supportedLocales: supportedLocales,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  onGenerateRoute: onGenerateAppRoute,
                  initialRoute: AppRoutes.splash,
                  builder: (context, child) {
                    return AppConnectivityGate(
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
