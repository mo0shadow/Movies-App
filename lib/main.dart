import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie/Core/Utils/app_routes.dart';
import 'package:movie/Feature/HomeScreen/home_screen.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_data_source_impelement.dart';
import 'package:movie/Feature/Onboeding/Reposatory/onboarding_%20repository_impelement.dart';
import 'package:movie/Feature/Onboeding/UI/onboarding_screen.dart';
import 'package:movie/l10n/app_language_provider.dart';
import 'package:movie/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // الشيك على الـ onboarding قبل تشغيل التطبيق
  final onboardingRepository = OnboardingRepositoryImplement(
    OnboardingDataSourceImplement(),
  );
  final isOnboardingSeen = await onboardingRepository.isOnboardingSeen();
  final initialRoute =
      isOnboardingSeen ? AppRoutes.homeScreen : AppRoutes.onboardingScreen;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<AppLanguageProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageProvider.applanguage,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: initialRoute,
      routes: {
        AppRoutes.onboardingScreen: (context) => OnboardingScreen(),
        AppRoutes.homeScreen: (context) => const HomeScreen(),
      },
    );
  }
}