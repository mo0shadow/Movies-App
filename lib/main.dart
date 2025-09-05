import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie/Feature/Onboeding/Repository/onboarding_%20repository_impelement.dart';
 import 'package:movie/Feature/Search/Data/RemoteData/remote_data_source_impl.dart';
import 'package:movie/Feature/Search/UI/search_provider.dart';
 import 'package:movie/Feature/Search/repository/serach_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'Core/Utils/app_routes.dart';
import 'Feature/Onboeding/DataSource/onboarding_data_source_impelement.dart';
import 'Feature/Onboeding/UI/onboarding_screen.dart';
import 'l10n/app_language_provider.dart';
import 'l10n/app_localizations.dart';
import 'Feature/HomeScreen/DataSource/Model/movie_models.dart';
import 'Feature/HomeScreen/UI/bottom_nav_bar.dart';
import 'Feature/HomeScreen/UI/home_provider.dart';
import 'Feature/HomeScreen/DataSource/Remote_Data/remote_data_source_implement.dart';
import 'Feature/HomeScreen/DataSource/Local_Data/local_data_source_implement.dart';
import 'Feature/HomeScreen/Repository/movie_repository_implement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  try {
    await Hive.initFlutter();

    // Register Hive Adapters
    Hive.registerAdapter(MovieResponseAdapter());
    Hive.registerAdapter(DataAdapter());
    Hive.registerAdapter(MetaAdapter());
    Hive.registerAdapter(MovieAdapter());
    Hive.registerAdapter(TorrentsAdapter());

    // Open Hive Boxes
    await Hive.openBox<Movie>('available_now_movies');
    await Hive.openBox<String>('movie_genres');
    await Hive.openBox<Movie>('search_results');
    await Hive.openBox<Movie>('movies_action');
    await Hive.openBox<Movie>('movies_comedy');
    await Hive.openBox<Movie>('movies_drama');
    await Hive.openBox<Movie>('movies_horror');
    await Hive.openBox<Movie>('movies_romance');
    await Hive.openBox<Movie>('movies_thriller');
    await Hive.openBox<Movie>('movies_animation');
    await Hive.openBox<Movie>('movies_sci-fi');
    await Hive.openBox<Movie>('movies_adventure');
    await Hive.openBox<Movie>('movies_fantasy');
    await Hive.openBox<Movie>('movies_crime');

    print("✅ Hive initialized and boxes opened successfully");
  } catch (e) {
    print("❌ Error initializing Hive or opening boxes: $e");
  }

  // Check onboarding status
  final onboardingRepository = OnboardingRepositoryImplement(
    OnboardingDataSourceImplement(),
  );
  final isOnboardingSeen = await onboardingRepository.isOnboardingSeen();
  final initialRoute = isOnboardingSeen
      ? AppRoutes.homeScreen
      : AppRoutes.onboardingScreen;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
          ChangeNotifierProvider(
            create: (_) => MovieProvider(
              movieRepository: MovieRepositoryImpl(
                RemoteDataSourceImpl(),
                LocalDataSourceImpl(),
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchProvider(
              repository: SearchRepositoryImpl(YtsDataSource()),
            ),
          ),
        ],
        child: MyApp(initialRoute: initialRoute),
      ),
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
      useInheritedMediaQuery: true,
      locale: languageProvider.applanguage  ,
      builder: DevicePreview.appBuilder,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: initialRoute,
      routes: {
        AppRoutes.onboardingScreen: (context) => OnboardingScreen(),
        AppRoutes.homeScreen: (context) => const BottomNavBar(),
      },
    );
  }
}