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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(partnerStaffProvider.notifier).fetch(),
    );
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
    final staffState = ref.watch(partnerStaffProvider);

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Row(
            children: [
              Icon(
                Icons.close,
                color: context.color.primary,
                size: 24,
              ),
              Text(
                context.locale.close,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
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
            child: staffState.when(
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
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
              data: (staffList) {
                final activeStaff = staffList
                    .where((s) => s.isActive)
                    .where((s) => s.name.toLowerCase().contains(_searchQuery))
                    .toList();

                if (activeStaff.isEmpty) {
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
                  itemCount: activeStaff.length,
                  separatorBuilder: (context, index) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final staff = activeStaff[index];
                    return _SelectableAttendantCard(
                      staff: staff,
                      index: index,
                      onTap: () => context.pop(staff),
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
