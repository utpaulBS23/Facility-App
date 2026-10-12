part of '../view/additional_income_page.dart';

/// Read-only view of one rent and others income: its details and the evidence
/// photo.
class _IncomeDetailsSheet extends StatelessWidget {
  const _IncomeDetailsSheet({required this.income, required this.typeLabel});

  final AdditionalIncomeEntity income;

  /// The income type's display label, resolved by the card.
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final description = income.description;
    final photoUrl = income.evidencePhotoUrl;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${income.localizedFacilityName(context.languageCode)} · '
                '${DateFormatter.shortDate(income.createdAt)}',
                style: context.textStyle.titleMedium.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(spacing.s16),
              Text(typeLabel, style: context.textStyle.bodyLarge),
              if (description != null && description.isNotEmpty) ...[
                Gap(spacing.s4),
                BodySmallText(description, color: color.text.secondary),
              ],
              Gap(spacing.s12),
              Text(
                context.numbers.currency(income.amount),
                style: context.textStyle.headlineTiny.copyWith(
                  color: color.primary,
                ),
              ),
              Gap(spacing.s12),
              BodySmallText(
                '${context.locale.submittedBy}: '
                '${income.localizedSubmittedByName(context.languageCode)}',
                color: color.text.secondary,
              ),
              if (photoUrl != null && photoUrl.isNotEmpty) ...[
                Gap(spacing.s16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius.r12),
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
