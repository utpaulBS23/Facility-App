part of '../view/claim_expense_page.dart';

class _ClaimExpenseLegRow extends StatelessWidget {
  const _ClaimExpenseLegRow({
    required this.leg,
    required this.transportModes,
    required this.onChanged,
    required this.onRemove,
    required this.showRemove,
  });

  final _LegDraft leg;
  final List<MasterDataItemEntity> transportModes;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;
  final bool showRemove;

  Future<void> _onPickMode(
    BuildContext context,
    FormFieldState<int> state,
  ) async {
    final result = await showModalBottomSheet<({int value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionPickerSheet<int>(
        title: context.locale.selectTransportMode,
        options: [
          for (final mode in transportModes)
            (value: mode.id, label: mode.label),
        ],
        isSelected: (value) => value == leg.vehicleTypeItemId,
      ),
    );
    if (result == null) return;
    leg.vehicleTypeItemId = result.value;
    state.didChange(result.value);
    onChanged();
  }

  String? _selectedModeLabel() => transportModes
      .cast<MasterDataItemEntity?>()
      .firstWhere((m) => m?.id == leg.vehicleTypeItemId, orElse: () => null)
      ?.label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormField<int>(
              initialValue: leg.vehicleTypeItemId,
              validator: (value) =>
                  value == null ? context.locale.selectTransportMode : null,
              builder: (state) {
                final selectedLabel = _selectedModeLabel();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormSelectorCard(
                      title: context.locale.transportModes,
                      icon: Icons.directions_car_outlined,
                      onTap: () => _onPickMode(context, state),
                      content: Text(
                        selectedLabel ?? context.locale.selectTransportMode,
                        overflow: TextOverflow.ellipsis,
                        style: selectedLabel == null
                            ? context.textStyle.bodyMedium.copyWith(
                                color: context.color.text.secondary,
                              )
                            : context.textStyle.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: spacing.s4,
                        left: spacing.s4,
                      ),
                      child: SizedBox(
                        height: spacing.s16,
                        child: state.hasError
                            ? Text(
                                state.errorText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.bodySmall.copyWith(
                                  color: context.color.error,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField.text(
                    controller: leg.distanceController,
                    label: context.locale.distanceKm,
                    hint: context.locale.distanceKm,
                    extraValidations: [PositiveNumberValidation()],
                    onChanged: (_) => onChanged(),
                  ),
                ),
                Gap(spacing.s8),
                Expanded(
                  child: AppTextField.text(
                    controller: leg.priceController,
                    label: context.locale.price,
                    hint: context.locale.price,
                    extraValidations: [PositiveNumberValidation()],
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            ),
            if (showRemove) ...[
              OutlinedButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: Text(context.locale.remove),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
