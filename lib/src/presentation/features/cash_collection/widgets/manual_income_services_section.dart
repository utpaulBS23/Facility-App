import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/item_stepper_input.dart';
import '../../../core/widgets/text/typography.dart';

class ManualIncomeServicesSection extends StatelessWidget {
  const ManualIncomeServicesSection({
    super.key,
    required this.servicesAsync,
    required this.quantities,
    required this.onChanged,
    required this.onRetry,
  });

  final AsyncValue<List<FacilityServiceEntity>>? servicesAsync;
  final Map<int, int> quantities;
  final void Function(int serviceId, int quantity) onChanged;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    Widget message(String text) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: BodySmallText(text, color: color.text.secondary),
    );

    final async = servicesAsync;
    if (async == null) {
      return message(context.locale.selectFacilityToListServices);
    }

    return async.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => AppErrorWidget(
        message: error.localizedMessage(context),
        onRetry: onRetry,
      ),
      data: (services) {
        if (services.isEmpty) {
          return message(context.locale.noServicesAtFacility);
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s16,
            vertical: spacing.s8,
          ),
          decoration: BoxDecoration(
            color: color.onPrimary,
            border: Border.all(color: color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          child: Column(
            children: [
              for (var i = 0; i < services.length; i++) ...[
                if (i > 0) Divider(color: color.borderSubtle, height: 1),
                _ServiceRow(
                  service: services[i],
                  quantity: quantities[services[i].id] ?? 0,
                  onChanged: (quantity) => onChanged(services[i].id, quantity),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.quantity,
    required this.onChanged,
  });

  final FacilityServiceEntity service;
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final gender = switch (service.gender) {
      'male' => context.locale.male,
      'female' => context.locale.female,
      final other => other,
    };

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.localizedServiceName(context.languageCode),
                  style: context.textStyle.labelLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(spacing.s2),
                BodySmallText(
                  '$gender · ${context.numbers.currency(service.price)}',
                  color: color.text.secondary,
                ),
              ],
            ),
          ),
          ItemStepperInput(quantity: quantity, min: 0, onChanged: onChanged),
        ],
      ),
    );
  }
}
