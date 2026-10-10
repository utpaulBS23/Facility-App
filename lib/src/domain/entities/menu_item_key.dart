/// Item keys the backend's menu configuration can place in the tab bar or
/// drawer. Wire values mirror the backend catalog.
///
/// WHY an enum: a key the app has no screen for resolves to null (skipped),
/// and every key we do know is forced to have an icon (see `MenuItemKeyIcon`)
/// by an exhaustive switch.
enum MenuItemKey {
  dashboard('dashboard'),
  shift('shift'),
  attendance('attendance'),
  myVisits('my_visits'),
  task('task'),
  tracking('tracking'),
  issue('issue'),
  profile('profile'),
  myAttendance('my_attendance'),
  extraCollection('extra_collection'),
  manualIncome('manual_income'),
  supplyRequest('supply_request'),
  stockBalance('stock_balance'),
  stockAveraging('stock_averaging'),
  leave('leave'),
  doorLock('door_lock'),
  expenseEntry('expense_entry'),
  claimExpense('claim_expense'),
  training('training'),
  profitReport('profit_report'),
  toiletLocation('toilet_location'),
  facilityLocations('facility_locations');

  const MenuItemKey(this.key);

  final String key;

  static final Map<String, MenuItemKey> _byKey = {
    for (final value in values) value.key: value,
  };

  static MenuItemKey? fromKey(String key) => _byKey[key];
}
