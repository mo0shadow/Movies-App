import 'package:flutter/material.dart';
import 'package:movie/Core/Utils/app_colors.dart';
import 'package:movie/Core/Utils/app_routes.dart';
import 'package:movie/Core/Utils/app_text_style.dart';
import 'package:movie/Feature/Onboeding/DataSource/onboarding_data_source_impelement.dart';
import 'package:movie/Feature/Onboeding/Reposatory/onboarding_%20repository_impelement.dart';
import 'package:movie/Feature/Onboeding/UI/onboarding_viewmodel.dart';
import 'package:movie/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingViewModel(
        OnboardingRepositoryImplement(OnboardingDataSourceImplement()),
      ),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);
    final pages = viewModel.getPages(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // عرض الصور فقط
          PageView.builder(
            controller: controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                viewModel.updatePage(index);
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(pages[index].image, fit: BoxFit.cover);
            },
          ),
          // الـ Bottom Sheet شبه الثابت في الأسفل
          IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: _bottomSheetColorByIndex(viewModel.currentPage),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.018,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // المحتوى: العنوان والوصف
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        pages[viewModel.currentPage].title,
                        style: _bottomSheetTitlByIndex(viewModel.currentPage),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: viewModel.currentPage == pages.length - 1
                            ? 0
                            : height * 0.01,
                      ),
                      Text(
                        pages[viewModel.currentPage].description ?? '',
                        style: _bottomSheetDescriptionByIndex(
                          viewModel.currentPage,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: viewModel.currentPage == pages.length - 1
                        ? 0
                        : height * 0.02,
                  ),
                  // Botton
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Finish or  Next or Explore Now Botton
                      if (viewModel.currentPage == pages.length - 1) ...[
                        SizedBox(
                          width: width * 0.95,
                          height: height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.finishOnboarding().then((_) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.homeScreen,
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.finish,
                              style: AppTextStyle.interW600Black20,
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: width * 0.95,
                          height: height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              viewModel.currentPage == 0
                                  ? AppLocalizations.of(context)!.explore_now
                                  : AppLocalizations.of(context)!.next,
                              style: AppTextStyle.interW600Black20,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: height * 0.01),

                      // Back Boutton
                      if (viewModel.currentPage > 1) ...[
                        SizedBox(
                          width: width * 0.95,
                          height: height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: AppColors.wight,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: AppColors.yellow,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.back,
                              style: AppTextStyle.interW600Yellow20,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //funcrion to change color of bottom sheet
  Color _bottomSheetColorByIndex(int index) {
    switch (index) {
      case 0:
        return AppColors.transparent;
      default:
        return Color(0xFF121312);
    }
  }

  //funcrion to change Style of title
  TextStyle _bottomSheetTitlByIndex(int index) {
    switch (index) {
      case 0:
        return AppTextStyle.interW500Wight30;
      default:
        return AppTextStyle.interW700Wight24;
    }
  }

  //funcrion to change Style of descripton
  TextStyle _bottomSheetDescriptionByIndex(int index) {
    switch (index) {
      case 0:
        return AppTextStyle.interW400Wight60Opacity16;
      default:
        return AppTextStyle.interW600Wight16;
    }
  }
}
