import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constant/app_texts.dart';
import 'core/di/inject.dart' as di;
import 'core/localization/app_language.dart';
import 'core/localization/language_cubit.dart';
import 'core/network/dio_client.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final storageService = di.sl<StorageService>();
  final dioClient = di.sl<DioClient>();
  final token = storageService.getToken();
  if (token != null) {
    dioClient.setAuthToken(token);
  }

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
        return BlocProvider.value(
          value: languageCubit,
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              AppTexts.updateLocale(locale);
              final supportedLocales = AppLanguage.values
                  .map((lang) => lang.locale)
                  .toList(growable: false);

              return MaterialApp(
                title: 'EFreeze',
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: supportedLocales,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                onGenerateRoute: onGenerateAppRoute,
                initialRoute: AppRoutes.splash,
              );
            },
          ),
        );
      },
    );
  }
}
