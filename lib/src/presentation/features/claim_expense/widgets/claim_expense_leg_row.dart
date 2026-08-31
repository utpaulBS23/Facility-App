part of '../view/claim_expense_page.dart';

class _ClaimExpenseLegRow extends StatelessWidget {
  const _ClaimExpenseLegRow({
    required this.leg,
    required this.onChanged,
    required this.onRemove,
    required this.showRemove,
  });

  final _LegDraft leg;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;
  final bool showRemove;

  String _modeLabel(BuildContext context, TransportMode mode) => switch (mode) {
    TransportMode.rickshaw => context.locale.transportModeRickshaw,
    TransportMode.bus => context.locale.transportModeBus,
    TransportMode.cng => context.locale.transportModeCng,
    TransportMode.bike => context.locale.transportModeBike,
    TransportMode.car => context.locale.transportModeCar,
    TransportMode.boat => context.locale.transportModeBoat,
    TransportMode.walking => context.locale.transportModeWalking,
    TransportMode.other => context.locale.transportModeOther,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: AppDropdownButtonFormField<TransportMode>(
            initialValue: leg.mode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            items: [
              for (final mode in TransportMode.values)
                DropdownMenuItem(
                  value: mode,
                  child: Text(_modeLabel(context, mode)),
                ),
            ],
            onChanged: (mode) {
              if (mode == null) return;
              leg.onModeChanged(mode);
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
            onChanged: (_) => onChanged(),
          ),
        ),
        Gap(spacing.s8),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: leg.rateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: context.locale.ratePerKm,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
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
