part of '../view/door_control_page.dart';

class _ReasonSelector extends ConsumerWidget {
  const _ReasonSelector({required this.selected, required this.onSelect});

  final DoorOpeningReason? selected;
  final ValueChanged<DoorOpeningReason>? onSelect;

  static const Map<String, IconData> _reasonIcons = {
    'cleaning': Icons.cleaning_services_outlined,
    'maintenance': Icons.build_outlined,
    'inspection': Icons.visibility_outlined,
    'default': Icons.help_outline,
  };

  IconData _getIconForReason(String key) {
    return _reasonIcons[key] ?? _reasonIcons['default']!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = context.dimensions;
    final session = ref.watch(authenticationRepositoryProvider).currentSession;
    final partnerId = session?.activePartnerId;

    if (partnerId == null) {
      return Text(
        'No partner found',
        style: context.textStyle.bodyMedium.copyWith(
          color: context.color.error,
        ),
      );
    }

    final reasonsAsync = ref.watch(doorOpeningReasonProvider(partnerId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(context.locale.reason),
        Gap(dimensions.spacing.s4),
        Text(
          context.locale.whyOpeningDoor,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        reasonsAsync.when(
          data: (reasons) {
            final locale = Localizations.localeOf(context).languageCode;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: dimensions.spacing.s12,
              mainAxisSpacing: dimensions.spacing.s12,
              childAspectRatio: 1.35,
              children: [
                for (final reason in reasons)
                  _OptionCard(
                    icon: _getIconForReason(reason.key),
                    title: reason.getLocalizedLabel(locale),
                    subtitle: '',
                    isSelected: selected?.id == reason.id,
                    onTap: onSelect == null ? null : () => onSelect!(reason),
                  ),
              ],
            );
          },
          loading: () => Center(
            child: SizedBox(
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => Text(
            'Error loading reasons',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.error,
            ),
          ),
        ),
      ],
    );
  }
}
