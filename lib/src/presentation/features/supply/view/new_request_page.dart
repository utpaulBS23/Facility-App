import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../../domain/repositories/supply_repository.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_supply_request_provider.dart';
import '../riverpod/item_catalog_provider.dart';
import '../widgets/facility_dropdown_card.dart';
import '../widgets/items_needed_card.dart';
import '../widgets/request_notes_card.dart';
import '../widgets/stock_mock_models.dart';
import '../widgets/urgency_selector_card.dart';

part '../widgets/new_request_footer_bar.dart';

class NewRequestPage extends ConsumerStatefulWidget {
  const NewRequestPage({super.key});

  @override
  ConsumerState<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends ConsumerState<NewRequestPage> {
  final _notesController = TextEditingController();

  ProviderSubscription<AsyncValue>? _createSub;

  int? _selectedFacilityId;
  SupplyUrgency _selectedUrgency = SupplyUrgency.normal;
  List<RequestItemEntry> _items = [const RequestItemEntry()];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _createSub = ref.listenManual(createSupplyRequestProvider, (_, next) {
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
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _createSub?.close();
    super.dispose();
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
      _items = [..._items, const RequestItemEntry()];
    });
  }

  void _onRemoveItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items = [..._items]..removeAt(index);
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_isSubmitting) return;
    final facilityId = _selectedFacilityId;
    final selectedItems = _items.where((item) => item.stockItemId != null);
    if (facilityId == null || selectedItems.isEmpty) return;

    setState(() => _isSubmitting = true);

    await ref.read(createSupplyRequestProvider.notifier).create(
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

    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final facilities = ref.watch(
      userSessionProvider.select((session) => session?.accessibleFacilities ?? const []),
    );
    _selectedFacilityId ??= facilities.isNotEmpty
        ? (facilities.where((f) => f.isPrimary).firstOrNull ?? facilities.first).id
        : null;

    final itemCatalogAsync = ref.watch(itemCatalogProvider(isActive: true));
    final availableItems = itemCatalogAsync.valueOrNull?.items ?? const <StockItemEntity>[];

    final canCreate = ref.watch(
      userSessionProvider.select(
        (session) => session?.can(UserPermission.supplyRequestCreate) ?? false,
      ),
    );
    final canSubmit = canCreate &&
        _selectedFacilityId != null &&
        _items.any((item) => item.stockItemId != null) &&
        !_isSubmitting;

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
      bottomNavigationBar: _NewRequestFooterBar(
        isSubmitting: _isSubmitting,
        canSubmit: canSubmit,
        onSubmit: _onSubmit,
        onCancel: () => context.pop(),
      ),
    );
  }
}
