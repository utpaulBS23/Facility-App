part of 'my_profile_page.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).valueOrNull;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    await ref.read(editProfileProvider.notifier).updateProfile(
          UpdateProfileEntity(
            name: name.isNotEmpty ? name : null,
            phoneNumber: phone.isNotEmpty ? phone : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    ref.listen(editProfileProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        AppSnackBar.showSuccess(context, context.locale.saveChanges);
        if (context.canPop()) {
          context.pop();
        }
      } else if (next is AsyncError) {
        final err = next.error;
        AppSnackBar.showError(
          context,
          err is Failure ? err.localizedMessage(context) : err.toString(),
        );
      }
    });

    final updateState = ref.watch(editProfileProvider);
    final isLoading = updateState.isLoading;

    final profile = ref.watch(profileProvider).valueOrNull;
    final name = profile?.name ?? '';

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
          context.locale.editProfile,
          style: textStyle.titleMedium.copyWith(
            color: color.text.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s16,
                vertical: spacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.s24,
                      horizontal: spacing.s16,
                    ),
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(context.radius.r12),
                      border: Border.all(color: color.borderSubtle),
                    ),
                    child: Center(
                      child: ProfileAvatarWithLabel(
                        initials: name,
                        imageUrl: profile?.profileImageUrl,
                        badgeIcon: Icons.camera_alt_outlined,
                        badgeColor: color.primary,
                        label: context.locale.changePicture,
                      ),
                    ),
                  ),
                  Gap(spacing.s24),
                  AppTextField.text(
                    controller: _nameController,
                    label: context.locale.name,
                    hint: context.locale.name,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  Gap(spacing.s16),
                  AppTextField.text(
                    controller: _phoneController,
                    label: context.locale.phoneNumber,
                    hint: context.locale.phoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s8,
                spacing.s16,
                spacing.s16,
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: color.primary,
                  minimumSize: Size(double.infinity, spacing.s44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radius.r12),
                  ),
                ),
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? SizedBox(
                        height: spacing.s20,
                        width: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(
                        context.locale.saveChanges,
                        style: textStyle.labelLarge.copyWith(
                          color: color.onPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
