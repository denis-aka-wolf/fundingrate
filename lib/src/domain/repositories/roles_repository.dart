import 'package:fundingrate/src/domain/entities/user.dart';

abstract class RolesRepository {
  Future<void> init();
  Future<UserRole?> getRole(int userId);
  Future<void> addRole(int userId, UserRole role);
  Future<void> removeRole(int userId, UserRole role);
  Future<List<int>> getAdminIds();
  Future<List<int>> getModeratorIds();
}
