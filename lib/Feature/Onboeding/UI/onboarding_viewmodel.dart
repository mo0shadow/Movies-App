import 'package:flutter/material.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_model.dart';
import 'package:movie/Feature/Onboeding/Reposatory/onboarding_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  final OnboardingRepository repository;
  int currentPage = 0;

  OnboardingViewModel(this.repository);

  List<OnboardingModel> getPages(BuildContext context) {
    return repository.getPages(context);
  }

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    await repository.setOnboardingSeen();
  }
}