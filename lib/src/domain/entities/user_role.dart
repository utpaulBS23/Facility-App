enum UserRole {
  attendant,
  supervisor,
  operationalManager,
  superAdmin,
  technician,
  other;

  static UserRole fromString(String? value) => switch (value) {
    'attendant' => UserRole.attendant,
    'supervisor' => UserRole.supervisor,
    'operational_manager' => UserRole.operationalManager,
    'super_admin' => UserRole.superAdmin,
    'technician' => UserRole.technician,
    _ => UserRole.other,
  };
}
