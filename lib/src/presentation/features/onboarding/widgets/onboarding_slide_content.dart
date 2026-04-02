part of '../view/onboarding_page.dart';

class _OnboardingSlideContent extends StatelessWidget {
  const _OnboardingSlideContent({required this.item});

  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dimensions.padding.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: context.color.disabled.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  context.dimensions.spacing.s16,
                ),
              ),
              child: Center(child: item.image),
            ),
          ),
          Gap(context.dimensions.spacing.s32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      height: 1.0,
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(context.dimensions.spacing.s8),
                  Text(
                    item.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: context.color.text.secondary,
                    ),
                  ),
                  Gap(context.dimensions.spacing.s24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
