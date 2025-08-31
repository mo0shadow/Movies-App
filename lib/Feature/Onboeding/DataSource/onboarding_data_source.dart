 import 'package:flutter/material.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_model.dart';

abstract class OnboardingDataSource {
  List<OnboardingModel> getOnboarding(BuildContext context);
}