part of '../view/add_additional_income_page.dart';

class _IncomeTypeSection extends ConsumerWidget {
  const _IncomeTypeSection({required this.hasError, required this.onSelected});

  final bool hasError;
  final VoidCallback onSelected;

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final options = ref.read(incomeTypeOptionsProvider).valueOrNull ??
        const <MasterDataItemEntity>[];
    if (options.isEmpty) return;

    final selected = await showModalBottomSheet<MasterDataItemEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IncomeTypePickerSheet(
        options: options,
        selected: ref.read(selectedIncomeTypeProvider),
      ),
    );

    if (selected != null) {
      ref.read(selectedIncomeTypeProvider.notifier).select(selected);
      onSelected();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeTypesAsync = ref.watch(incomeTypeOptionsProvider);
    final incomeType = ref.watch(selectedIncomeTypeProvider);

    return incomeTypesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => BodySmallText(
        context.locale.selectIncomeType,
        color: context.color.error,
      ),
      data: (options) => _DropdownField(
        value: incomeType?.label,
        hint: context.locale.selectIncomeType,
        hasError: hasError,
        onTap: options.isEmpty ? null : () => _onTap(context, ref),
      ),
    );
  }
}

class _IncomeTypePickerSheet extends StatelessWidget {
  const _IncomeTypePickerSheet({required this.options, required this.selected});

  final List<MasterDataItemEntity> options;
  final MasterDataItemEntity? selected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: spacing.s40,
            height: spacing.s4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.selectIncomeType),
          ),
          Gap(spacing.s16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              itemCount: options.length,
              separatorBuilder: (_, _) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option.value == selected?.value;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(option),
                  child: Container(
                    padding: EdgeInsets.all(spacing.s16),
                    decoration: BoxDecoration(
                      color: context.color.onPrimary,
                      border: Border.all(
                        color: isSelected
                            ? context.color.primary
                            : context.color.borderSubtle,
                      ),
                      borderRadius: BorderRadius.circular(radius.r12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: LabelLargeText(
                            option.label,
                            color: isSelected
                                ? context.color.primary
                                : context.color.text.primary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: context.color.primary,
                            size: spacing.s20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
