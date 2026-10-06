import '../widgets/dashboard_chart_common.dart';
import '../widgets/dashboard_tone.dart';
import '../widgets/donut_chart.dart';
import '../widgets/facility_card.dart';
import '../widgets/issue_summary_card.dart';
import '../widgets/staff_shortage_alert.dart';

// TODO: hardcoded sample content for every role's dashboard. Replace with API
// data once the dashboard endpoints are documented. English only until then.

const sampleDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const sampleShortages = [
  StaffShortageRow(
    facility: 'Mirpur 1',
    slot: 'Mirpur morning shift',
    when: 'Starts 8:00 AM',
    peopleText: '2 person',
    assignLabel: 'Assign staff for Mirpur 1',
  ),
  StaffShortageRow(
    facility: 'Dhanmondi Market Restrooms',
    slot: 'Dhanmondi morning shift',
    when: 'Starts 8:00 AM',
    peopleText: '1 person',
    assignLabel: 'Assign staff for Dhanmondi Market Restrooms',
  ),
  StaffShortageRow(
    facility: 'Gulshan-2 Market Toilet',
    slot: 'Gulshan day shift',
    when: 'Starts 10:00 AM',
    peopleText: '3 person',
    assignLabel: 'Assign staff for Gulshan-2 Market Toilet',
  ),
  StaffShortageRow(
    facility: 'Banani Square Restrooms',
    slot: 'Banani evening shift',
    when: 'Starts 2:00 PM',
    peopleText: '1 person',
    assignLabel: 'Assign staff for Banani Square Restrooms',
  ),
];

const sampleCollectionSeries = [
  ChartSeries(
    name: 'Achieved',
    tone: DashboardTone.brand,
    area: true,
    values: [1850, 2100, 1720, 2380, 2210, 2540, 2180],
  ),
  ChartSeries(
    name: 'Target',
    tone: DashboardTone.neutral,
    dashed: true,
    values: [2000, 2000, 2000, 2000, 2000, 2000, 2000],
  ),
];

const sampleVisitorSeries = [
  ChartSeries(
    name: 'Male',
    tone: DashboardTone.blue,
    values: [142, 150, 138, 161, 155, 190, 176],
  ),
  ChartSeries(
    name: 'Female',
    tone: DashboardTone.brand,
    values: [96, 101, 92, 110, 104, 128, 119],
  ),
];

const sampleMonths = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];

const sampleRevenueSeries = [
  ChartSeries(
    name: 'Revenue',
    tone: DashboardTone.brand,
    area: true,
    values: [38200, 41000, 39500, 43200, 43100, 45000],
  ),
  ChartSeries(
    name: 'Target',
    tone: DashboardTone.neutral,
    dashed: true,
    values: [42000, 42000, 42000, 42000, 42000, 42000],
  ),
];

const sampleExecutiveLabels = ['Karim', 'Sabbir', 'Tania'];

const sampleExecutiveSeries = [
  ChartSeries(
    name: 'Target',
    tone: DashboardTone.neutral,
    values: [42000, 27000, 30000],
  ),
  ChartSeries(
    name: 'Achieved',
    tone: DashboardTone.brand,
    values: [27800, 14800, 19100],
  ),
];

const sampleIssueSlices = [
  DonutSlice(label: 'Open', value: 2, tone: DashboardTone.red),
  DonutSlice(label: 'In progress', value: 3, tone: DashboardTone.orange),
  DonutSlice(label: 'Assigned', value: 1, tone: DashboardTone.blue),
  DonutSlice(label: 'Solved', value: 3, tone: DashboardTone.green),
];

const sampleIssueCounts = [
  IssueCount(valueText: '2', label: 'Critical', tone: DashboardTone.red),
  IssueCount(valueText: '4', label: 'Medium', tone: DashboardTone.orange),
  IssueCount(valueText: '9', label: 'Total issue', tone: DashboardTone.blue),
  IssueCount(valueText: '3', label: 'Solved', tone: DashboardTone.green),
];

/// One facility of an executive or of the facility summary.
class SampleFacility {
  const SampleFacility({
    required this.name,
    required this.pct,
    required this.expense,
    required this.male,
    required this.female,
    this.target = 15000,
    this.inProgress = 0,
    this.completed = 0,
    this.pending = 0,
    this.aqi = 10,
    this.aqiLabel = 'Good',
    this.aqiTone = DashboardTone.green,
  });

  final String name;
  final int pct;
  final int expense;
  final int male;
  final int female;
  final int target;
  final int inProgress;
  final int completed;
  final int pending;
  final int aqi;
  final String aqiLabel;
  final DashboardTone aqiTone;

  FacilityCardData toCard() {
    final total = male + female;
    final malePct = total == 0 ? 0 : (male / total * 100).round();
    return FacilityCardData(
      name: name,
      percent: pct,
      pctText: '$pct%',
      achievedText: '৳ ${_money(target * pct ~/ 100)} achieved',
      targetText: 'Target ৳ ${_money(target)}',
      expenseText: '৳ ${_money(expense)}',
      maleCount: male,
      femaleCount: female,
      maleText: '$male ($malePct%)',
      femaleText: '$female (${100 - malePct}%)',
      totalVisitorsText: '$total total',
      inProgressText: '$inProgress',
      completedText: '$completed',
      pendingText: '$pending',
      aqiText: '$aqi',
      aqiLabel: aqiLabel,
      aqiTone: aqiTone,
    );
  }
}

String _money(int v) {
  final s = v.toString();
  final out = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) out.write(',');
    out.write(s[i]);
  }
  return out.toString();
}

String sampleMoney(int v) => _money(v);

const sampleFacilities = [
  SampleFacility(
    name: 'Mirpur-10 Public Toilet Complex',
    pct: 63,
    expense: 3200,
    male: 142,
    female: 96,
    inProgress: 3,
    completed: 1,
    pending: 1,
  ),
  SampleFacility(
    name: 'Dhanmondi Market Restrooms',
    pct: 83,
    expense: 4100,
    male: 188,
    female: 121,
    inProgress: 1,
    completed: 4,
    aqi: 24,
    aqiLabel: 'Moderate',
    aqiTone: DashboardTone.orange,
  ),
  SampleFacility(
    name: 'Gulshan-2 Market Toilet',
    pct: 49,
    expense: 2750,
    male: 97,
    female: 64,
    inProgress: 2,
    pending: 3,
    aqi: 41,
    aqiLabel: 'Poor',
    aqiTone: DashboardTone.red,
  ),
];

/// An executive and the facilities they run.
class SampleExecutive {
  const SampleExecutive({
    required this.name,
    required this.target,
    required this.facilities,
  });

  final String name;
  final int target;
  final List<SampleFacility> facilities;
}

const sampleExecutives = [
  SampleExecutive(
    name: 'Karim Uddin',
    target: 42000,
    facilities: [
      SampleFacility(
        name: 'Mirpur-10 Public Toilet Complex',
        pct: 63,
        expense: 3200,
        male: 142,
        female: 96,
      ),
      SampleFacility(
        name: 'Dhanmondi Market Restrooms',
        pct: 83,
        expense: 4100,
        male: 188,
        female: 121,
      ),
      SampleFacility(
        name: 'Gulshan-2 Market Toilet',
        pct: 49,
        expense: 2750,
        male: 97,
        female: 64,
      ),
    ],
  ),
  SampleExecutive(
    name: 'Sabbir Hasan',
    target: 27000,
    facilities: [
      SampleFacility(
        name: 'Banani Square Restrooms',
        pct: 81,
        expense: 3600,
        male: 160,
        female: 112,
      ),
      SampleFacility(
        name: 'Uttara Sector-7 Toilet',
        pct: 26,
        expense: 1900,
        male: 58,
        female: 41,
      ),
    ],
  ),
  SampleExecutive(
    name: 'Tania Akter',
    target: 30000,
    facilities: [
      SampleFacility(
        name: 'Mohakhali Bus Terminal Toilet',
        pct: 72,
        expense: 3900,
        male: 210,
        female: 133,
      ),
      SampleFacility(
        name: 'Farmgate Underpass Restroom',
        pct: 58,
        expense: 2400,
        male: 120,
        female: 88,
      ),
    ],
  ),
];

/// A ranked revenue line.
class SampleRevenue {
  const SampleRevenue({
    required this.rank,
    required this.name,
    required this.amount,
    required this.percent,
    required this.delta,
    required this.tone,
  });

  final int rank;
  final String name;
  final int amount;
  final int percent;
  final int delta;
  final DashboardTone tone;
}

const sampleTopRevenue = [
  SampleRevenue(
    rank: 1,
    name: 'Dhanmondi Market Restrooms',
    amount: 12500,
    percent: 83,
    delta: 6,
    tone: DashboardTone.green,
  ),
  SampleRevenue(
    rank: 2,
    name: 'Banani Square Restrooms',
    amount: 9750,
    percent: 81,
    delta: 3,
    tone: DashboardTone.green,
  ),
  SampleRevenue(
    rank: 3,
    name: 'Mirpur-10 Public Toilet Complex',
    amount: 9450,
    percent: 63,
    delta: -2,
    tone: DashboardTone.green,
  ),
];

const sampleLowRevenue = [
  SampleRevenue(
    rank: 6,
    name: 'Uttara Sector-7 Toilet',
    amount: 3100,
    percent: 26,
    delta: -11,
    tone: DashboardTone.red,
  ),
  SampleRevenue(
    rank: 5,
    name: 'Dhanmondi Park Restroom',
    amount: 4320,
    percent: 36,
    delta: -5,
    tone: DashboardTone.red,
  ),
  SampleRevenue(
    rank: 4,
    name: 'Gulshan-2 Market Toilet',
    amount: 5880,
    percent: 49,
    delta: -9,
    tone: DashboardTone.red,
  ),
];

/// A recent issue.
class SampleIssue {
  const SampleIssue({
    required this.title,
    required this.facility,
    required this.status,
    required this.tone,
  });

  final String title;
  final String facility;
  final String status;
  final DashboardTone tone;
}

const sampleRecentIssues = [
  SampleIssue(
    title: 'Water leak',
    facility: 'Mirpur-10 Public Toilet Complex',
    status: 'Open',
    tone: DashboardTone.red,
  ),
  SampleIssue(
    title: 'Power problem',
    facility: 'Dhanmondi Market Restrooms',
    status: 'Ongoing',
    tone: DashboardTone.orange,
  ),
  SampleIssue(
    title: 'Cleaning needed',
    facility: 'Gulshan-2 Market Toilet',
    status: 'Assigned',
    tone: DashboardTone.blue,
  ),
];
