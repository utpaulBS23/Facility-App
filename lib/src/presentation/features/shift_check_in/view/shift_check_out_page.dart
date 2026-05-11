part of 'shift_check_in_page.dart';

class ShiftCheckOutPage extends ConsumerStatefulWidget {
  const ShiftCheckOutPage({super.key});

  @override
  ConsumerState<ShiftCheckOutPage> createState() => _ShiftCheckOutPageState();
}

class _ShiftCheckOutPageState extends ConsumerState<ShiftCheckOutPage> {
  void _onSubmit(String? photoPath) {
    if (photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.locale.photoRequired),
          backgroundColor: context.color.error,
        ),
      );
      return;
    }
    final partnerId = ref.read(getCurrentUserUseCaseProvider).call()?.partnerId;
    if (partnerId == null) return;
    ref
        .read(faceValidationProvider.notifier)
        .validate(partnerId: partnerId, imagePath: photoPath);
  }

  void _onTakePhoto() {
    ref.read(selfiePickerProvider.notifier).pickSelfie();
  }

  void _onRequestSupervisor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimensions.radius.r12),
        ),
      ),
      builder: (_) => const _RequestSupervisorApprovalBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(faceValidationProvider, (_, next) async {
      if (next.hasValue && next.value != null) {
        await ref.read(logoutUseCaseProvider).call();
        if (context.mounted) context.goNamed(Routes.login);
      }
    });

    final selfieState = ref.watch(selfiePickerProvider);
    final photoPath = selfieState.valueOrNull;
    final validationState = ref.watch(faceValidationProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Headline2xlTinyText(context.locale.checkOut),
        ),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ShiftCheckInBody(
        capturedPhotoPath: photoPath,
        isLoading: selfieState.isLoading,
        isValidating: validationState.isLoading,
        hasError: selfieState.hasError,
        errorMessage: selfieState.error?.toString(),
        faceValidationError: validationState.error?.toString(),
        onTakePhoto: _onTakePhoto,
        onRequestSupervisor: _onRequestSupervisor,
        onSubmit: () => _onSubmit(photoPath),
      ),
    );
  }
}
