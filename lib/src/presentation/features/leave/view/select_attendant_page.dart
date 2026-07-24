part of 'apply_leave_page.dart';

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
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;
    final attendantsState = ref.watch(leaveAttendantsProvider);

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: EdgeInsetsGeometry.directional(start: 6),
            child: Row(
              children: [
                Icon(Icons.close, color: context.color.primary, size: 24),
                Text(
                  context.locale.close,
                  style: context.textStyle.labelXl.copyWith(
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.attendant),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s12,
            ),
            child: AppTextField.search(
              controller: _searchController,
              hint: context.locale.search,
            ),
          ),
          Expanded(
            child: attendantsState.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, _) => Center(
                child: Padding(
                  padding: EdgeInsets.all(spacing.s24),
                  child: Text(
                    err.toString(),
                    style: textStyle.bodyMedium.copyWith(
                      color: color.text.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (attendantsList) {
                final filtered = attendantsList
                    .where((s) => s.name.toLowerCase().contains(_searchQuery))
                    .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      context.locale.noAttendantsFound,
                      style: textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
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
