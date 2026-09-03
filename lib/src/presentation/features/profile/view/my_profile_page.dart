import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/profile_payloads.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../riverpod/edit_profile_provider.dart';
import '../riverpod/profile_provider.dart';
import '../widgets/auth_header_icon.dart';
import '../widgets/profile_avatar_badge.dart';
import '../widgets/profile_info_divider.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/profile_role_chip.dart';
import '../widgets/settings_action_tile.dart';

part 'edit_profile_page.dart';
part 'change_password_page.dart';
part 'password_reset_page.dart';
part 'otp_verification_page.dart';

class MyProfilePage extends ConsumerWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: color.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: color.primary, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: Text(
          context.locale.myProfile,
          style: textStyle.titleMedium.copyWith(
            color: color.text.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorWidget(
          message: err is Failure
              ? err.localizedMessage(context)
              : err.toString(),
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (profile) {
          final name = profile.name;
          final email = profile.email;
          final phone = profile.phoneNumber.isEmpty ? '—' : profile.phoneNumber;
          final role = profile.userType;
          final partner = profile.partnerName.isEmpty ? '—' : profile.partnerName;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(profileProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s16,
                vertical: spacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(context.radius.r12),
                      border: Border.all(color: color.borderSubtle),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: spacing.s24,
                            horizontal: spacing.s16,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                ProfileAvatarBadge(
                                  initials: name,
                                  imageUrl: profile.profileImageUrl,
                                  badgeIcon: Icons.check,
                                  badgeColor: color.success,
                                ),
                                Gap(spacing.s12),
                                Text(
                                  name,
                                  style: textStyle.titleMedium.copyWith(
                                    color: color.text.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(spacing.s4),
                                Text(
                                  email,
                                  style: textStyle.bodySmall.copyWith(
                                    color: color.text.secondary,
                                  ),
                                ),
                                Gap(spacing.s8),
                                ProfileRoleChip(role: role),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: spacing.s16,
                          right: spacing.s16,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.borderSubtle.withValues(alpha: 0.7),
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  context.pushNamed(Routes.editProfile),
                              icon: Icon(Icons.edit_outlined,
                                  color: color.overlay),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(spacing.s24),
                  Text(
                    context.locale.personalInformation,
                    style: textStyle.bodyLarge.copyWith(
                      color: color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(spacing.s12),
                  Container(
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(context.radius.r12),
                      border: Border.all(color: color.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        ProfileInfoRow(
                          icon: Icons.person_outline,
                          label: context.locale.name,
                          value: name,
                        ),
                        ProfileInfoDivider(),
                        ProfileInfoRow(
                          icon: Icons.email_outlined,
                          label: context.locale.email,
                          value: email,
                        ),
                        ProfileInfoDivider(),
                        ProfileInfoRow(
                          icon: Icons.phone_outlined,
                          label: context.locale.phoneNumber,
                          value: phone,
                        ),
                        ProfileInfoDivider(),
                        ProfileInfoRow(
                          icon: Icons.business_outlined,
                          label: context.locale.facility,
                          value: partner,
                        ),
                      ],
                    ),
                  ),
                  Gap(spacing.s16),
                  Container(
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(context.radius.r12),
                      border: Border.all(color: color.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        SettingsActionTile(
                          icon: Icons.lock_outline,
                          title: context.locale.changePassword,
                          subtitle: context.locale.changePasswordSubtitle,
                          onTap: () => context.pushNamed(Routes.changePassword),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
