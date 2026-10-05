import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../riverpod/user_tracking_provider.dart';
import '../widgets/user_position_card.dart';
import '../widgets/user_position_sheet.dart';
import '../widgets/user_status_chips.dart';
import '../widgets/user_tracking_map.dart';
import '../widgets/user_tracking_style.dart';

/// The Tracking tab: where users are right now, with their status.
class SupervisorTrackingPage extends ConsumerStatefulWidget {
  const SupervisorTrackingPage({super.key});

  @override
  ConsumerState<SupervisorTrackingPage> createState() =>
      _SupervisorTrackingPageState();
}

class _SupervisorTrackingPageState extends ConsumerState<SupervisorTrackingPage>
    with WidgetsBindingObserver {
  UserStatusFilter _filter = UserStatusFilter.all;
  int? _selectedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // WHY: positions go stale while the app is in the background.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() => ref.invalidate(userTrackingProvider);

  void _select(UserPositionEntity position) {
    setState(() => _selectedUserId = position.userId);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => UserPositionSheet(position: position),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userTrackingProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      // WHY: the bottom bar is hidden on this screen (see NavigationShell), so
      // the back button is the way out, to the Menu tab.
      appBar: DetailAppBar(
        title: context.locale.tracking,
        onBack: () => context.goNamed(Routes.menu),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (_, _) => AppErrorWidget(
          message: context.locale.somethingWentWrong,
          onRetry: _refresh,
        ),
        data: _buildData,
      ),
    );
  }

  Widget _buildData(UserTrackingEntity data) {
    final spacing = context.dimensions.spacing;
    final numbers = context.numbers;
    final visible = [
      for (final p in data.positions)
        if (switch (_filter) {
          UserStatusFilter.all => true,
          UserStatusFilter.online => p.online,
          UserStatusFilter.offline => !p.online,
        })
          p,
    ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.locale.usersOnlineSummary(
                  numbers.integer(data.onlineCount),
                  numbers.integer(data.positions.length),
                ),
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              SizedBox(height: spacing.s8),
              UserStatusChips(
                data: data,
                selected: _filter,
                onSelected: (filter) => setState(() {
                  _filter = filter;
                  _selectedUserId = null;
                }),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: UserTrackingMap(
            positions: visible,
            selectedUserId: _selectedUserId,
            onUserTap: _select,
          ),
        ),
        Expanded(
          flex: 4,
          child: visible.isEmpty
              ? Center(child: Text(context.locale.noUsersMatchFilters))
              : ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => SizedBox(height: spacing.s8),
                  itemBuilder: (context, index) {
                    final position = visible[index];
                    return UserPositionCard(
                      position: position,
                      selected: position.userId == _selectedUserId,
                      onTap: () => _select(position),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
