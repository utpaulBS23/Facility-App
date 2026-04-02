import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';

part '../model/onboarding_model.dart';
part '../widgets/onboarding_slide_content.dart';
part '../widgets/progress_indicator_row.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted && _currentPage < _getOnboardingItems(context).length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    _animationController.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _animationController.forward();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _getOnboardingItems(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.dimensions.padding.p16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimensions.padding.p24,
                ),
                child: _ProgressIndicatorRow(
                  items: items,
                  currentPage: _currentPage,
                  animationController: _animationController,
                ),
              ),
              Gap(context.dimensions.spacing.s32),
              Expanded(
                child: GestureDetector(
                  onPanDown: (_) => _animationController.stop(),
                  onPanCancel: () => _animationController.forward(),
                  onPanEnd: (_) => _animationController.forward(),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() => _currentPage = page);
                      _animationController.forward(from: 0.0);
                    },
                    children: items.map((item) {
                      return _OnboardingSlideContent(item: item);
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimensions.padding.p24,
                ),
                child: Column(
                  spacing: context.dimensions.spacing.s12,
                  children: [
                    FilledButton(
                      onPressed: () {
                        context.pushNamed(Routes.countrySelection);
                      },
                      child: Text(context.locale.signUp),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        context.goNamed(Routes.login);
                      },
                      child: Text(context.locale.login),
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
