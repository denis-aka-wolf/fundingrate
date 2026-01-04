import 'package:fundingrate/src/domain/entities/user.dart';
import 'package:fundingrate/src/domain/repositories/config_repository.dart';
import 'package:fundingrate/src/domain/repositories/roles_repository.dart';

// Config UseCases
class GetConfig {
  final ConfigRepository repository;
  GetConfig(this.repository);
  Future<Map<String, dynamic>> call() => repository.getAll();
}

class SetConfig {
  final ConfigRepository repository;
  SetConfig(this.repository);
  Future<bool> call(String key, dynamic value) => repository.set(key, value);
}

// Roles UseCases
class GetRole {
  final RolesRepository repository;
  GetRole(this.repository);
  Future<UserRole?> call(int userId) => repository.getRole(userId);
}

class AddRole {
  final RolesRepository repository;
  AddRole(this.repository);
  Future<void> call(int userId, UserRole role) =>
      repository.addRole(userId, role);
}

class RemoveRole {
  final RolesRepository repository;
  RemoveRole(this.repository);
  Future<void> call(int userId, UserRole role) =>
      repository.removeRole(userId, role);
}

class GetAdminIds {
  final RolesRepository repository;
  GetAdminIds(this.repository);
  Future<List<int>> call() => repository.getAdminIds();
}

class GetModeratorIds {
  final RolesRepository repository;
  GetModeratorIds(this.repository);
  Future<List<int>> call() => repository.getModeratorIds();
}
