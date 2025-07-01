import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maaya/domain/entities/onboarding_model.dart';
import 'package:maaya/presentation/controllers/onboarding_controller.dart';
import 'package:maaya/presentation/widgets/language_selector.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  _OnboardingBodyState createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  List<OnboardingModel> get pages => [
    OnboardingModel(
      image: 'assets/images/onboarding_first_pic.svg',
      title: 'onboarding_first_title'.tr,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_second_pic.svg',
      title: 'onboarding_second_title'.tr,
    ),
  ];

  void nextPage() {
    if (controller.currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      controller.nextPageOrFinish();
      Get.offAllNamed('/home');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Get.locale?.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                reverse: isArabic,
                itemCount: pages.length,
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                itemBuilder: (context, index) {
                  final model = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const Spacer(),
                        SvgPicture.asset(model.image, width: 250, height: 250),
                        const SizedBox(height: 30),
                        Text(
                          model.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  );
                },
              ),

              Positioned(
                top: 40,
                left: isArabic ? 30 : null,
                right: isArabic ? null : 30,
                child: Obx(
                  () =>
                      controller.currentPage.value == 0
                          ? GestureDetector(
                            onTap: controller.skip,
                            child: Text(
                              'skip'.tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),

              Positioned(
                top: 30,
                right: isArabic ? 30 : null,
                left: isArabic ? null : 30,
                child: LanguageSelector(),
              ),

              Positioned(
                bottom: 45,
                left: 14,
                right: 14,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pages.length, (index) {
                          final actualIndex =
                              isArabic ? pages.length - 1 - index : index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width:
                                controller.currentPage.value == actualIndex
                                    ? 20
                                    : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  controller.currentPage.value == actualIndex
                                      ? theme.primaryColor
                                      : theme.disabledColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            controller.currentPage.value == pages.length - 1
                                ? 'start'.tr
                                : 'next'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
