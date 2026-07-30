import 'package:facility_management_app/src/presentation/core/widgets/app_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/leave_attendants_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/selectable_attendant_card.dart';
part '../widgets/shimmer/attendant_shimmer.dart';

class SelectAttendantPage extends ConsumerStatefulWidget {
  const SelectAttendantPage({super.key});

  @override
  ConsumerState<SelectAttendantPage> createState() =>
      _SelectAttendantPageState();
}

class _SelectAttendantPageState extends ConsumerState<SelectAttendantPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final attendantsState = ref.watch(leaveAttendantsProvider);

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: context.dimensions.spacing.s100,
        title: Headline2xlTinyText(context.locale.selectAttendant),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s8,
            ),
            child: AppTextField.search(
              controller: _searchController,
              hint: context.locale.search,
            ),
          ),
          Expanded(
            child: attendantsState.when(
              loading: () => const _AttendantListShimmer(),
              error: (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(leaveAttendantsProvider),
              ),
              data: (attendants) {
                final filtered = attendants.where((a) {
                  if (_searchQuery.isEmpty) return true;
                  return a.name.toLowerCase().contains(_searchQuery) ||
                      a.uid.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      context.locale.noAttendantsFound,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final attendant = filtered[index];
                    return _SelectableAttendantCard(
                      attendant: attendant,
                      index: index,
                      onTap: () => context.pop(attendant),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
