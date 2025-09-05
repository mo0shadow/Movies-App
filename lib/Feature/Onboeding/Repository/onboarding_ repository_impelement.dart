import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_data_source.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_model.dart';
import 'onboarding_repository.dart';

class OnboardingRepositoryImplement implements OnboardingRepository {
  final OnboardingDataSource dataSource;

  OnboardingRepositoryImplement(this.dataSource);

  @override
  List<OnboardingModel> getPages(BuildContext context) {
    return dataSource.getOnboarding(context);
  }

  @override
  Future<bool> isOnboardingSeen() async {
    final box = await Hive.openBox("settings");
    return box.get("onboarding_seen", defaultValue: false);
  }

  @override
  Future<void> setOnboardingSeen() async {
    final box = await Hive.openBox("settings");
    await box.put("onboarding_seen", true);
  }
}
