// Author: Md. Shahin Bashar
// Created: 2026-04-03

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/check_in_info_provider.dart';
import '../riverpod/selfie_picker_provider.dart';

part '../widgets/auto_detected_info_card.dart';
part '../widgets/selfie_zone.dart';
part '../widgets/shift_check_in_body.dart';
part '../widgets/submit_button.dart';

class ShiftCheckInPage extends ConsumerWidget {
  const ShiftCheckInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selfiePickerProvider);
    final photoPath = state.valueOrNull;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Headline2xlTinyText(context.locale.shiftCheckIn),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ShiftCheckInBody(
        capturedPhotoPath: photoPath,
        isLoading: state.isLoading,
        onTakePhoto: () => ref.read(selfiePickerProvider.notifier).pickSelfie(),
        onSubmit: () => _onSubmit(context, photoPath),
      ),
    );
  }

  void _onSubmit(BuildContext context, String? photoPath) {
    if (photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.locale.photoRequired),
          backgroundColor: context.color.error,
        ),
      );

      return;
    }
    // TODO: Implement check-in submission
  }
}
