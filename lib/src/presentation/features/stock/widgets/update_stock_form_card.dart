part of '../view/update_stock_page.dart';

class _UpdateStockBody extends StatelessWidget {
  const _UpdateStockBody({required this.targets, required this.controllers});

  final List<FacilityStockTargetEntity> targets;
  final Map<int, TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _InstructionAlertBanner(),
          Gap(spacing.s16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: targets.length,
            separatorBuilder: (context, index) => Gap(spacing.s12),
            itemBuilder: (context, index) {
              final target = targets[index];

              return _UpdateStockFormCard(
                target: target,
                currentBalController: controllers[target.stockItemId]!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UpdateStockFormCard extends StatelessWidget {
  const _UpdateStockFormCard({
    required this.target,
    required this.currentBalController,
  });

  final FacilityStockTargetEntity target;
  final TextEditingController currentBalController;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            target.itemName,
            style: context.textStyle.bodyLarge.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s4),
          Text(
            context.locale.itemCodeLabel(target.itemCode),
            style: context.textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s12,
              vertical: spacing.s4,
            ),
            decoration: BoxDecoration(
              color: color.scaffoldBackground,
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(radius.r10),
            ),
            child: Row(
              children: [
                Text(
                  context.locale.currentBalance,
                  style: context.textStyle.labelSmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: spacing.s56,
                  child: TextField(
                    controller: currentBalController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: color.text.primary,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  target.unit,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
