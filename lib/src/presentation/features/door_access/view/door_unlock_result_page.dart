import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/door_lock_action_provider.dart';
import 'package:gap/gap.dart';

class DoorUnlockResultPage extends StatefulWidget {
  const DoorUnlockResultPage({super.key, this.result});

  final DoorUnlockResult? result;

  @override
  State<DoorUnlockResultPage> createState() => _DoorUnlockResultPageState();
}

class _DoorUnlockResultPageState extends State<DoorUnlockResultPage> {
  late int _secondsRemaining;
  late final Future<void> _startTimer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = 10;
    _startTimer = _startCountdown();
  }

  Future<void> _startCountdown() async {
    for (int i = 10; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _secondsRemaining = i - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final time = widget.result != null
        ? TimeOfDay.fromDateTime(widget.result!.timestamp).format(context)
        : '';

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: colors.primary,
        leading: const SizedBox.shrink(),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(dimensions.padding.p16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.success.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.verified_outlined,
                          color: colors.success,
                          size: 48,
                        ),
                      ),
                      Gap(dimensions.spacing.s24),
                      Text(
                        context.locale.doorUnlockedSuccessfully,
                        textAlign: TextAlign.center,
                        style: context.textStyle.headlineMedium.copyWith(
                          color: colors.text.primary,
                        ),
                      ),
                      Gap(dimensions.spacing.s16),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.padding.p16,
                          vertical: dimensions.padding.p16,
                        ),
                        decoration: BoxDecoration(
                          color: colors.info.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(dimensions.radius.r6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Auto close in ',
                              style: context.textStyle.bodySmall.copyWith(
                                color: colors.text.secondary,
                              ),
                            ),
                            Text(
                              '$_secondsRemaining s',
                              style: context.textStyle.bodySmall.copyWith(
                                color: colors.info,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(dimensions.spacing.s16),
                      if (widget.result != null) ...[
                        Container(
                          padding: EdgeInsets.all(dimensions.padding.p16),
                          decoration: BoxDecoration(
                            color: colors.onPrimary,
                            border: Border.all(color: colors.borderSubtle),
                            borderRadius:
                                BorderRadius.circular(dimensions.radius.r12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summary',
                                style: context.textStyle.bodySmallUppercase
                                    .copyWith(
                                  color: colors.text.secondary,
                                ),
                              ),
                              Gap(dimensions.spacing.s8),
                              Text(
                                widget.result!.summary,
                                style: context.textStyle.bodyRegular.copyWith(
                                  color: colors.text.primary,
                                ),
                              ),
                              Gap(dimensions.spacing.s12),
                              Text(
                                'Time',
                                style: context.textStyle.bodySmallUppercase
                                    .copyWith(
                                  color: colors.text.secondary,
                                ),
                              ),
                              Gap(dimensions.spacing.s4),
                              Text(
                                time,
                                style: context.textStyle.bodySmall.copyWith(
                                  color: colors.text.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(dimensions.spacing.s16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: dimensions.padding.p16,
                            vertical: dimensions.padding.p16,
                          ),
                          decoration: BoxDecoration(
                            color: colors.success.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(dimensions.radius.r6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: colors.success,
                                size: 20,
                              ),
                              Gap(dimensions.spacing.s8),
                              Expanded(
                                child: Text(
                                  'Auth code saved for next use',
                                  style:
                                      context.textStyle.bodySmall.copyWith(
                                    color: colors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: dimensions.padding.p16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
