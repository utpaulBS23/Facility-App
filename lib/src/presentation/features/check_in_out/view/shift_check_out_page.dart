part of 'shift_check_in_page.dart';

class ShiftCheckOutPage extends ConsumerStatefulWidget {
  const ShiftCheckOutPage({super.key, required this.shiftId});

  final int shiftId;

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
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    ref.read(checkOutProvider.notifier).checkOut(
      partnerId: partnerId,
      shiftId: widget.shiftId,
      imagePath: photoPath,
      lat: checkInInfo.latitude,
      lng: checkInInfo.longitude,
      address: checkInInfo.location,
    );
  }

  void _onTakePhoto() {
    ref.read(selfiePickerProvider.notifier).pickSelfie();
  }

  void _onRequestSupervisor() {
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimensions.radius.r12),
        ),
      ),
      builder: (_) => _ManualAttendanceBottomSheet(
        checkInInfo: checkInInfo,
        withdrawRoute: Routes.shiftCheckOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkOutProvider, (_, next) async {
      if (next.hasValue && next.value != null) {
        await ref.read(logoutUseCaseProvider).call();
        if (context.mounted) context.goNamed(Routes.login);
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: context.color.error,
          ),
        );
      }
    });

    final selfieState = ref.watch(selfiePickerProvider);
    final photoPath = selfieState.valueOrNull;
    final checkOutState = ref.watch(checkOutProvider);

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
        isValidating: checkOutState.isLoading,
        hasError: selfieState.hasError,
        errorMessage: selfieState.error?.toString(),
        faceValidationError: checkOutState.error?.toString(),
        onTakePhoto: _onTakePhoto,
        onRequestSupervisor: _onRequestSupervisor,
        onSubmit: () => _onSubmit(photoPath),
      ),
    );
  }
}
