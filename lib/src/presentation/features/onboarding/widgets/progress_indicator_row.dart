part of '../view/onboarding_page.dart';

class _ProgressIndicatorRow extends StatelessWidget {
  const _ProgressIndicatorRow({
    required this.items,
    required this.currentPage,
    required this.animationController,
  });

  final List<_OnboardingItem> items;
  final int currentPage;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: context.dimensions.spacing.s2,
            ),
            height: context.dimensions.spacing.s6,
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: context.color.pageView.inactive,
              borderRadius: BorderRadius.circular(
                context.dimensions.spacing.s8,
              ),
            ),
            child: item.index < currentPage
                ? Container(color: context.color.pageView.active)
                : item.index == currentPage
                ? AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        widthFactor: animationController.value,
                        child: Container(color: context.color.pageView.active),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        );
      }).toList(),
    );
  }
}
