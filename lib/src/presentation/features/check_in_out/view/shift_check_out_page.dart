part of 'shift_check_in_page.dart';

/// Check-out requires a selfie, same capture flow as [ShiftCheckInPage] —
/// just no manual-supervisor fallback, since there is no manual check-out
/// path on the backend.
class ShiftCheckOutPage extends ConsumerStatefulWidget {
  const ShiftCheckOutPage({super.key, required this.attendanceId});

  final int attendanceId;

  @override
  ConsumerState<ShiftCheckOutPage> createState() => _ShiftCheckOutPageState();
}

class _ShiftCheckOutPageState extends ConsumerState<ShiftCheckOutPage> {
  Future<void> _onTakePhoto() async {
    final path = await context.pushNamed<String?>(Routes.selfieCamera);
    if (path == null || !mounted) return;
    ref.read(selfiePickerProvider.notifier).capturePhoto(path);
  }

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
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    // WHY: no upload-to-storage step exists yet — see the matching comment
    // in ShiftCheckInPage._onSubmit.
    ref
        .read(checkOutProvider.notifier)
        .checkOut(
          attendanceId: widget.attendanceId,
          lat: checkInInfo.latitude,
          lng: checkInInfo.longitude,
          selfieUrl: photoPath,
        );
  }

  // WHY: the shift tab's slots list is fetched once on mount, so a check-out
  // made from here would otherwise leave it showing pre-check-out state until
  // the user manually changes the date.
  void _refreshShiftSlots() {
    // WHY facilityId re-sent: without it, a supervisor filtered to a
    // non-default facility would have this refresh silently fall back to
    // the session's primary facility (see GetShiftSlotsUseCase), discarding
    // their filter selection.
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          facilityId: ref.read(shiftSlotsProvider).valueOrNull?.facility?.id,
        );
  }

  void _showResult(CheckOutEntity? entity) {
    final messages = (entity?.warnings ?? const [])
        .map((warning) => warning.message)
        .where((message) => message.isNotEmpty)
        .toList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messages.isNotEmpty
              ? messages.join('\n')
              : context.locale.approvalSuccessfulMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkOutProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        final entity = (next.value as Success<CheckOutEntity, Failure>).data;
        _showResult(entity);
        _refreshShiftSlots();
        context.goNamed(Routes.shift);
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!.localizedMessage(context)),
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
      appBar: DetailAppBar(title: context.locale.checkOut),
      body: _ShiftCheckOutBody(
        capturedPhotoPath: photoPath,
        isLoading: selfieState.isLoading,
        isSubmitting: checkOutState.isLoading,
        hasError: selfieState.hasError,
        errorMessage: selfieState.error?.toString(),
        onTakePhoto: _onTakePhoto,
        onSubmit: () => _onSubmit(photoPath),
      ),
    );
  }
}

class _ShiftCheckOutBody extends StatelessWidget {
  const _ShiftCheckOutBody({
    required this.capturedPhotoPath,
    required this.isLoading,
    required this.isSubmitting,
    required this.hasError,
    this.errorMessage,
    required this.onTakePhoto,
    required this.onSubmit,
  });

  final String? capturedPhotoPath;
  final bool isLoading;
  final bool isSubmitting;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback onTakePhoto;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              dimensions.padding.p16,
              dimensions.padding.p16,
              dimensions.padding.p16,
              0,
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  _SelfieZone(
                    capturedPhotoPath: capturedPhotoPath,
                    hasError: hasError,
                    errorMessage: errorMessage,
                    onRetry: onTakePhoto,
                  ),
                  Gap(dimensions.spacing.s12),
                  _TakePhotoButton(
                    capturedPhotoPath: capturedPhotoPath,
                    isLoading: isLoading,
                    onTap: onTakePhoto,
                  ),
                  Gap(dimensions.spacing.s16),
                  const _AutoDetectedInfoCard(),
                  Gap(dimensions.spacing.s16),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              dimensions.padding.p16,
              dimensions.spacing.s8,
              dimensions.padding.p16,
              dimensions.spacing.s16,
            ),
            child: _SubmitButton(onSubmit: onSubmit, isLoading: isSubmitting),
          ),
        ),
      ],
    );
  }
}
