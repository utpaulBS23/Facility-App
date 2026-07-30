import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/form_dialog_shell.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_roster_provider.dart';
import '../riverpod/facility_list_provider.dart';
import '../riverpod/publish_roster_provider.dart';
import '../riverpod/roster_list_provider.dart';
import '../riverpod/shift_global_config_provider.dart';

part '../widgets/create_roster_dialog.dart';
part '../widgets/create_roster_dialog_active_days_field.dart';
part '../widgets/create_roster_dialog_facility_field.dart';
part '../widgets/create_roster_dialog_field_label.dart';
part '../widgets/create_roster_dialog_info_box.dart';
part '../widgets/create_roster_dialog_week_start_field.dart';
part '../widgets/day_chip_selector.dart';
part '../widgets/roster_card.dart';
part '../widgets/roster_card_active_days_row.dart';
part '../widgets/roster_card_labeled_text.dart';
part '../widgets/roster_card_pill.dart';
part '../widgets/roster_list_body.dart';

class RosterListPage extends ConsumerStatefulWidget {
  const RosterListPage({super.key});

  @override
  ConsumerState<RosterListPage> createState() => _RosterListPageState();
}

class _RosterListPageState extends ConsumerState<RosterListPage> {
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadFacilities(),
      ref.read(shiftGlobalConfigProvider.notifier).fetch(),
    ]);
  }

  Future<void> _loadFacilities() async {
    await ref.read(facilityListProvider.notifier).fetch();
    final facilities = ref.read(facilityListProvider).valueOrNull;
    if (facilities == null || facilities.isEmpty || !mounted) return;
    _onFacilitySelected(facilities.first.id);
  }

  void _onFacilitySelected(int facilityId) {
    setState(() => _selectedFacilityId = facilityId);
    ref.read(rosterListProvider.notifier).fetch(facilityId: facilityId);
  }

  void _onRosterTap(RosterEntity roster) {
    context.pushNamed(Routes.rosterShifts, extra: roster);
  }

  Future<void> _onCreateRoster() async {
    final facilityId = _selectedFacilityId;
    final weekStartDay = await _resolveWeekStartDay();
    if (!mounted || weekStartDay == null) return;

    final created = await showDialog<bool>(
      context: context,
      builder: (_) => CreateRosterDialog(
        initialFacilityId: facilityId,
        weekStartDay: weekStartDay,
      ),
    );
    if (created != true || !mounted) return;

    final createdFacilityId = ref
        .read(createRosterProvider)
        .valueOrNull
        ?.facilityId;
    final refreshFacilityId = createdFacilityId ?? facilityId;
    if (refreshFacilityId != null) {
      _onFacilitySelected(refreshFacilityId);
    }
  }

  Future<int?> _resolveWeekStartDay() async {
    final configState = ref.read(shiftGlobalConfigProvider);
    final weekStartDay = configState.valueOrNull?.weekStartDay;
    if (weekStartDay != null) return weekStartDay;

    if (configState.isLoading) {
      _showSnackBar(context.locale.loading);
      return null;
    }

    await ref.read(shiftGlobalConfigProvider.notifier).fetch();
    if (!mounted) return null;

    final refreshedState = ref.read(shiftGlobalConfigProvider);
    final refreshedWeekStartDay = refreshedState.valueOrNull?.weekStartDay;
    if (refreshedWeekStartDay != null) return refreshedWeekStartDay;

    if (refreshedState case AsyncError(:final error)) {
      _showSnackBar(error.localizedMessage(context));
    }

    return null;
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilityListProvider);
    final rosterState = ref.watch(rosterListProvider);
    final shiftGlobalConfigState = ref.watch(shiftGlobalConfigProvider);

    ref.listen(publishRosterProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.rosterPublishedSuccessfully)),
        );
        final facilityId = _selectedFacilityId;
        if (facilityId != null) {
          ref.read(rosterListProvider.notifier).fetch(facilityId: facilityId);
        }
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!.localizedMessage(context))),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: DisplaySmallText(context.locale.rosters),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: PermissionGate(
        permissions: [UserPermission.rosterCreate],
        child: FloatingActionButton(
          onPressed: _onCreateRoster,
          tooltip: shiftGlobalConfigState.isLoading
              ? context.locale.loading
              : null,
          child: const Icon(Icons.add_rounded),
        ),
      ),
      body: _RosterListBody(
        facilitiesState: facilitiesState,
        rosterState: rosterState,
        selectedFacilityId: _selectedFacilityId,
        onFacilitySelected: _onFacilitySelected,
        onRosterTap: _onRosterTap,
      ),
    );
  }
}
