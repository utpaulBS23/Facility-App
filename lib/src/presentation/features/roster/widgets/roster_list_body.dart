part of '../view/roster_list_page.dart';

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
                  error: (err, _) =>
                      Center(child: _ErrorText(err.localizedMessage(context))),
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

    return AppDropdownButtonFormField<int>(
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
