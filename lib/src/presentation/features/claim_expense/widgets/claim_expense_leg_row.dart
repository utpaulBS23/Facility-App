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

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: AppDropdownButtonFormField<int>(
            initialValue: leg.vehicleTypeItemId,
            hint: Text(context.locale.selectTransportMode),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            items: [
              for (final mode in transportModes)
                DropdownMenuItem(value: mode.id, child: Text(mode.label)),
            ],
            validator: (value) =>
                value == null ? context.locale.selectTransportMode : null,
            onChanged: (id) {
              leg.vehicleTypeItemId = id;
              onChanged();
            },
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: leg.distanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: context.locale.distanceKm,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            validator: (value) {
              final distance = double.tryParse(value?.trim() ?? '');
              return distance == null || distance <= 0
                  ? context.locale.distanceKm
                  : null;
            },
            onChanged: (_) => onChanged(),
          ),
        ),
        if (showRemove) ...[
          Gap(spacing.s4),
          IconButton(
            icon: Icon(Icons.close, color: context.color.icon),
            onPressed: onRemove,
          ),
        ],
      ],
    );
  }
}
