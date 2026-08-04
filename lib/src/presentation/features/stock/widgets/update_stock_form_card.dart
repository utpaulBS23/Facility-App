part of '../view/update_stock_page.dart';

class _UpdateStockFormCard extends StatelessWidget {
  const _UpdateStockFormCard({
    required this.item,
    required this.currentBalController,
    required this.notesController,
  });

  final MockStockItem item;
  final TextEditingController currentBalController;
  final TextEditingController notesController;

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s10),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
                child: Icon(
                  item.icon,
                  color: color.primary,
                  size: 20,
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.textStyle.bodyLarge.copyWith(
                        color: color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(spacing.s2),
                    Text(
                      item.category,
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(spacing.s16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s12),
                    decoration: BoxDecoration(
                      color: color.scaffoldBackground,
                      border: Border.all(color: color.borderSubtle),
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Previous Balance',
                          style: context.textStyle.labelSmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${item.quantity}',
                              style: context.textStyle.bodyLarge.copyWith(
                                color: color.text.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item.unit,
                              style: context.textStyle.bodySmall.copyWith(
                                color: color.text.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(spacing.s12),
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      border: Border.all(color: color.borderSubtle),
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Balance',
                          style: context.textStyle.labelSmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                        Gap(spacing.s4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 56,
                              child: TextField(
                                controller: currentBalController,
                                keyboardType: TextInputType.number,
                                cursorHeight: 18,
                                textAlignVertical: TextAlignVertical.center,
                                style: context.textStyle.bodyLarge.copyWith(
                                  color: color.text.primary,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  counterText: '',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: spacing.s4,
                                    vertical: spacing.s2,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              item.unit,
                              style: context.textStyle.bodySmall.copyWith(
                                color: color.text.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(spacing.s12),
          TextField(
            controller: notesController,
            decoration: InputDecoration(
              hintText: 'Add note (optional)',
              hintStyle: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.s12,
                vertical: spacing.s10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
