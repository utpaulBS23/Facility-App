import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_route_entity.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../riverpod/user_route_provider.dart';
import 'route_leg_card.dart';
import 'route_map.dart';

/// The Visited Route tab: pick a user and a day, see the route they travelled.
///
/// WHY users come from live positions: the API guide has no user-list
/// endpoint, and the people worth tracing are the ones being tracked.
class VisitedRouteView extends ConsumerStatefulWidget {
  const VisitedRouteView({super.key, required this.users});

  final List<UserPositionEntity> users;

  @override
  ConsumerState<VisitedRouteView> createState() => _VisitedRouteViewState();
}

class _VisitedRouteViewState extends ConsumerState<VisitedRouteView> {
  int? _userId;
  late DateTime _date = _today();
  int? _selectedLegId;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final today = _today();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(today.year - 1),
      lastDate: today,
    );
    if (picked == null) return;
    setState(() {
      _date = DateTime(picked.year, picked.month, picked.day);
      _selectedLegId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: context.color.onPrimary,
          padding: EdgeInsets.fromLTRB(
            spacing.s16,
            spacing.s8,
            spacing.s16,
            spacing.s12,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _userId,
                    hint: Text(context.locale.selectUser),
                    items: [
                      for (final user in widget.users)
                        DropdownMenuItem(
                          value: user.userId,
                          child: Text(
                            user.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (id) => setState(() {
                      _userId = id;
                      _selectedLegId = null;
                    }),
                  ),
                ),
              ),
              SizedBox(width: spacing.s12),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                label: Text(DateFormatter.shortDate(_date)),
              ),
            ],
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    final userId = _userId;
    if (userId == null) {
      return Center(child: Text(context.locale.selectUserToViewRoute));
    }
    final state = ref.watch(userRouteProvider(userId: userId, date: _date));
    return state.when(
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, _) => AppErrorWidget(
        message: context.locale.somethingWentWrong,
        onRetry: () =>
            ref.invalidate(userRouteProvider(userId: userId, date: _date)),
      ),
      data: _buildRoute,
    );
  }

  Widget _buildRoute(UserRouteEntity route) {
    if (route.legs.isEmpty) {
      return Center(child: Text(context.locale.noTravelData));
    }
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: RouteMap(legs: route.legs, selectedLegId: _selectedLegId),
        ),
        Expanded(
          flex: 4,
          child: ListView.separated(
            padding: EdgeInsets.all(spacing.s16),
            itemCount: route.legs.length,
            separatorBuilder: (_, _) => SizedBox(height: spacing.s8),
            itemBuilder: (context, index) {
              final leg = route.legs[index];
              return RouteLegCard(
                index: index,
                leg: leg,
                selected: leg.id == _selectedLegId,
                onTap: () => setState(
                  () =>
                      _selectedLegId = leg.id == _selectedLegId ? null : leg.id,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
