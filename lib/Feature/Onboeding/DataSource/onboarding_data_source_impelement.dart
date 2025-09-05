import 'package:flutter/material.dart';
import 'package:movie/Core/Utils/app_assets.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_data_source.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_model.dart';
import 'package:movie/l10n/app_localizations.dart';

class OnboardingDataSourceImplement implements OnboardingDataSource {
  @override
  List<OnboardingModel> getOnboarding(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return [
      OnboardingModel(
        title: localization.onboarding_title1,
        description: localization.onboarding_desc1,
        image: AppAssets.onboarding1,
      ),
      OnboardingModel(
        title: localization.onboarding_title2,
        description: localization.onboarding_desc2,
        image: AppAssets.onboarding2,
      ),
      OnboardingModel(
        title: localization.onboarding_title3,
        description: localization.onboarding_desc3,
        image: AppAssets.onboarding3,
      ),
      OnboardingModel(
        title: localization.onboarding_title4,
        description: localization.onboarding_desc4,
        image: AppAssets.onboarding4,
      ),
      OnboardingModel(
        title: localization.onboarding_title5,
        description: localization.onboarding_desc5,
        image: AppAssets.onboarding5,
      ),
      OnboardingModel(
        title: localization.onboarding_title6,
        image: AppAssets.onboarding6,
      ),
    ];
  }
}
