enum UserRole {
  admin,
  moderator;

  static UserRole? fromString(String? role) {
    if (role == 'admin') return UserRole.admin;
    if (role == 'moderator') return UserRole.moderator;
    return null;
  }
}
