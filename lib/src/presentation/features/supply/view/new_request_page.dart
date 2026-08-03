import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../../domain/repositories/supply_repository.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_supply_request_provider.dart';
import '../riverpod/item_catalog_provider.dart';
import '../widgets/facility_dropdown_card.dart';
import '../widgets/items_needed_card.dart';
import '../widgets/request_notes_card.dart';
import '../widgets/urgency_selector_card.dart';

part '../widgets/new_request_footer_bar.dart';

class NewRequestPage extends ConsumerStatefulWidget {
  const NewRequestPage({super.key});

  @override
  ConsumerState<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends ConsumerState<NewRequestPage> {
  final _notesController = TextEditingController();

  int? _selectedFacilityId;
  SupplyUrgency _selectedUrgency = SupplyUrgency.normal;
  List<NewRequestItemFormEntry> _items = [const NewRequestItemFormEntry()];

  @override
  void initState() {
    super.initState();
    ref.listenManual(createSupplyRequestProvider, _onCreateStateChanged);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onCreateStateChanged(
    AsyncValue<SupplyRequestEntity?>? previous,
    AsyncValue<SupplyRequestEntity?> next,
  ) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) return;
        AppSnackBar.showSuccess(
          context,
          context.locale.requestSubmittedSuccessfully,
        );
        context.pop();
      },
      error: (e, _) {
        if (!mounted) return;
        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  void _onItemSelected(int index, StockItemEntity item) {
    setState(() {
      _items[index] = _items[index].copyWith(
        stockItemId: item.id,
        itemName: item.name,
        unit: item.unit,
      );
    });
  }

  void _onQuantityChanged(int index, int quantity) {
    setState(() {
      _items[index] = _items[index].copyWith(quantity: quantity);
    });
  }

  void _onAddItem() {
    setState(() {
      _items = [..._items, const NewRequestItemFormEntry()];
    });
  }

  void _onRemoveItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items = [..._items]..removeAt(index);
      });
    }
  }

  void _onSubmit() {
    final facilityId = _selectedFacilityId;
    final selectedItems = _items.where((item) => item.stockItemId != null);
    if (facilityId == null || selectedItems.isEmpty) return;

    ref.read(createSupplyRequestProvider.notifier).create(
          facilityId: facilityId,
          urgency: _selectedUrgency,
          notes: _notesController.text.trim(),
          items: selectedItems
              .map((item) => CreateSupplyRequestItemParams(
                    stockItemId: item.stockItemId!,
                    qtyRequested: item.quantity.toDouble(),
                  ))
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final createRequestState = ref.watch(createSupplyRequestProvider);

    final facilities = ref.watch(
      userSessionProvider.select((session) => session?.accessibleFacilities ?? const []),
    );
    _selectedFacilityId ??= facilities.isNotEmpty
        ? (facilities.where((f) => f.isPrimary).firstOrNull ?? facilities.first).id
        : null;

    final itemCatalogAsync = ref.watch(itemCatalogProvider(true));
    final availableItems = itemCatalogAsync.valueOrNull?.items ?? const <StockItemEntity>[];

    final canSubmit = _selectedFacilityId != null &&
        _items.any((item) => item.stockItemId != null) &&
        !createRequestState.isLoading;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.newRequestTitle),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FacilityDropdownCard(
              selectedFacilityId: _selectedFacilityId,
              facilities: facilities,
              onChanged: (val) => setState(() => _selectedFacilityId = val),
            ),
            Gap(spacing.s16),
            ItemsNeededCard(
              items: _items,
              availableItems: availableItems,
              onItemSelected: _onItemSelected,
              onQuantityChanged: _onQuantityChanged,
              onAddItem: _onAddItem,
              onRemoveItem: _onRemoveItem,
            ),
            Gap(spacing.s16),
            UrgencySelectorCard(
              selectedUrgency: _selectedUrgency,
              onChanged: (val) => setState(() => _selectedUrgency = val),
            ),
            Gap(spacing.s16),
            RequestNotesCard(controller: _notesController),
            Gap(spacing.s24),
          ],
        ),
      ),
      bottomNavigationBar: PermissionGate(
        permissions: const [UserPermission.supplyRequestCreate],
        child: _NewRequestFooterBar(
          isSubmitting: createRequestState.isLoading,
          canSubmit: canSubmit,
          onSubmit: _onSubmit,
          onCancel: () => context.pop(),
        ),
      ),
    );
  }
}
