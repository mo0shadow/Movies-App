import 'package:flutter/widgets.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_model.dart';

abstract class OnboardingRepository {
  List<OnboardingModel> getPages(BuildContext context);
  Future<void> setOnboardingSeen();
  Future<bool> isOnboardingSeen();
}
