part of '../view/new_request_page.dart';

class _NewRequestBody extends StatelessWidget {
  const _NewRequestBody({
    required this.selectedFacilityId,
    required this.facilities,
    required this.onFacilityChanged,
    required this.items,
    required this.availableItems,
    required this.onItemSelected,
    required this.onQuantityChanged,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.selectedUrgency,
    required this.onUrgencyChanged,
    required this.notesController,
  });

  final int? selectedFacilityId;
  final List<AccessibleFacilityEntity> facilities;
  final ValueChanged<int?> onFacilityChanged;
  final List<NewRequestItemFormEntry> items;
  final List<StockItemEntity> availableItems;
  final void Function(int index, StockItemEntity item) onItemSelected;
  final void Function(int index, int quantity) onQuantityChanged;
  final VoidCallback onAddItem;
  final ValueChanged<int> onRemoveItem;
  final SupplyUrgency selectedUrgency;
  final ValueChanged<SupplyUrgency> onUrgencyChanged;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FacilityDropdownCard(
            selectedFacilityId: selectedFacilityId,
            facilities: facilities,
            onChanged: onFacilityChanged,
          ),
          Gap(spacing.s16),
          ItemsNeededCard(
            items: items,
            availableItems: availableItems,
            onItemSelected: onItemSelected,
            onQuantityChanged: onQuantityChanged,
            onAddItem: onAddItem,
            onRemoveItem: onRemoveItem,
          ),
          Gap(spacing.s16),
          UrgencySelectorCard(
            selectedUrgency: selectedUrgency,
            onChanged: onUrgencyChanged,
          ),
          Gap(spacing.s16),
          RequestNotesCard(controller: notesController),
          Gap(spacing.s24),
        ],
      ),
    );
  }
}
