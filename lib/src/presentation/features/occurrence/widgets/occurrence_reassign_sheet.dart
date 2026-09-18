part of '../view/occurrence_page.dart';

class _OccurrenceReassignSheet extends ConsumerStatefulWidget {
  const _OccurrenceReassignSheet({required this.occurrence});

  final TaskOccurrenceEntity occurrence;

  @override
  ConsumerState<_OccurrenceReassignSheet> createState() =>
      _OccurrenceReassignSheetState();
}

class _OccurrenceReassignSheetState
    extends ConsumerState<_OccurrenceReassignSheet> {
  final _searchController = TextEditingController();
  String _search = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => setState(() => _search = value.trim()),
    );
  }

  Future<void> _onPick(int attendantId) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(taskOccurrenceReassignProvider.notifier)
        .reassign(
          taskOccurrenceId: widget.occurrence.id,
          assignedTo: attendantId,
        );
    if (!context.mounted) return;
    navigator.pop();
    result.when(
      success: (_) => messenger.showSnackBar(
        SnackBar(content: Text(context.locale.occurrenceReassignSuccess)),
      ),
      error: (error) => messenger.showSnackBar(
        SnackBar(content: Text(error.localized(context))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final staffAsync = ref.watch(
      occurrenceFacilityStaffProvider(
        facilityId: widget.occurrence.facilityId,
        search: _search.isEmpty ? null : _search,
      ),
    );

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: .vertical(top: .circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Gap(spacing.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: .circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.assignResponsibility),
          ),
          Gap(spacing.s12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: AppTextField.search(
              controller: _searchController,
              hint: context.locale.search,
              onChanged: _onSearchChanged,
            ),
          ),
          Gap(spacing.s8),
          Flexible(
            child: staffAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, _) => Center(
                child: BodySmallText(
                  err.toString(),
                  color: context.color.error,
                ),
              ),
              data: (staff) {
                if (staff.isEmpty) {
                  return Center(
                    child: BodySmallText(
                      context.locale.occurrenceAttendantPickerEmpty,
                      color: context.color.text.secondary,
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    0,
                    spacing.s16,
                    spacing.s16,
                  ),
                  itemCount: staff.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final attendant = staff[index];
                    return StaffTile(
                      staff: attendant,
                      isSelected: false,
                      onAssign: () => _onPick(attendant.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
