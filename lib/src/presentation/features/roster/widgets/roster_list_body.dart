part of '../view/roster_list_page.dart';

class _RosterListBody extends StatelessWidget {
  const _RosterListBody({
    required this.facilities,
    required this.rosterState,
    required this.selectedFacilityId,
    required this.onFacilitySelected,
    required this.onRosterTap,
  });

  final List<AccessibleFacilityEntity> facilities;
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
          child: FacilityDropdown(
            facilities: facilities,
            selectedFacilityId: selectedFacilityId,
            onChanged: onFacilitySelected,
          ),
        ),
        Expanded(
          child: rosterState.when(
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
