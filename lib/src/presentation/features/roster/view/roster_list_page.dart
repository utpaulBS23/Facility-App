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
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_roster_provider.dart';
import '../riverpod/facility_list_provider.dart';
import '../riverpod/publish_roster_provider.dart';
import '../riverpod/roster_list_provider.dart';

part '../widgets/create_roster_dialog.dart';
part '../widgets/day_chip_selector.dart';
part '../widgets/roster_card.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFacilities());
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
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => CreateRosterDialog(initialFacilityId: facilityId),
    );
    if (created != true || !mounted) return;
    final refreshId = ref.read(createRosterProvider).valueOrNull?.facilityId;
    _onFacilitySelected(refreshId ?? facilityId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilitiesState = ref.watch(facilityListProvider);
    final rosterState = ref.watch(rosterListProvider);

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!.localizedMessage(context))));
      }
    });

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.rosters),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: PermissionGate(
        permission: AppPermission.rosterCreate,
        child: FloatingActionButton(
          onPressed: _onCreateRoster,
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

class _RosterListBody extends StatelessWidget {
  const _RosterListBody({
    required this.facilitiesState,
    required this.rosterState,
    required this.selectedFacilityId,
    required this.onFacilitySelected,
    required this.onRosterTap,
  });

  final AsyncValue<List<FacilityEntity>> facilitiesState;
  final AsyncValue<RosterListEntity?> rosterState;
  final int? selectedFacilityId;
  final ValueChanged<int> onFacilitySelected;
  final ValueChanged<RosterEntity> onRosterTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.s16,
            spacing.s12,
            spacing.s16,
            spacing.s4,
          ),
          child: facilitiesState.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => _ErrorText(err.localizedMessage(context)),
            data: (facilities) => _FacilityDropdown(
              facilities: facilities,
              selectedFacilityId: selectedFacilityId,
              onChanged: onFacilitySelected,
            ),
          ),
        ),
        Expanded(
          // WHY: rosterState's initial value is AsyncData(null) —
          // indistinguishable from "fetched, no rosters" — so while
          // facilities are still loading (and no fetch has started yet) this
          // would otherwise flash "No rosters found" under the dropdown's
          // own loading spinner.
          child: facilitiesState.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : rosterState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (err, _) => Center(child: _ErrorText(err.localizedMessage(context))),
                  data: (data) => _RosterList(
                    rosters: data?.rosters ?? const [],
                    onTap: onRosterTap,
                  ),
                ),
        ),
      ],
    );
  }
}

class _RosterList extends StatelessWidget {
  const _RosterList({required this.rosters, required this.onTap});

  final List<RosterEntity> rosters;
  final ValueChanged<RosterEntity> onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    if (rosters.isEmpty) {
      return Center(
        child: Text(
          context.locale.noRostersFound,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        spacing.s12,
        spacing.s16,
        spacing.s96,
      ),
      itemCount: rosters.length,
      separatorBuilder: (context, index) => Gap(spacing.s12),
      itemBuilder: (context, index) => _RosterCard(
        roster: rosters[index],
        onTap: () => onTap(rosters[index]),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.textStyle.bodyMedium.copyWith(
        color: context.color.text.secondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _FacilityDropdown extends StatelessWidget {
  const _FacilityDropdown({
    required this.facilities,
    required this.selectedFacilityId,
    required this.onChanged,
  });

  final List<FacilityEntity> facilities;
  final int? selectedFacilityId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) return const SizedBox.shrink();

    return DropdownButtonFormField<int>(
      initialValue: selectedFacilityId,
      decoration: InputDecoration(
        labelText: context.locale.facilityName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
        ),
      ),
      items: [
        for (final facility in facilities)
          DropdownMenuItem(value: facility.id, child: Text(facility.name)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
