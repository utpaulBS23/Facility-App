import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../../domain/entities/menu_item_key.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/menu_item_app_bar.dart';
import 'door_control_page.dart';

/// Door Control as a bottom-bar tab. The pushed route takes its facility as an
/// argument from the Menu page; a tab has no such argument, so it uses the
/// user's primary facility, as the Menu row does.
class DoorControlTabPage extends ConsumerWidget {
  const DoorControlTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];

    if (facilities.isEmpty) {
      return Scaffold(
        backgroundColor: context.color.scaffoldBackground,
        appBar: MenuItemAppBar(
          itemKey: MenuItemKey.doorLock,
          fallbackTitle: context.locale.doorControl,
        ),
        body: Center(child: Text(context.locale.noFacilityAssigned)),
      );
    }

    final selected = facilities.firstWhere(
      (facility) => facility.isPrimary,
      orElse: () => facilities.first,
    );

    return DoorControlPage(
      facility: FacilityEntity(
        id: selected.id,
        name: selected.name,
        nameBn: selected.nameBn,
        address: '',
      ),
    );
  }
}
