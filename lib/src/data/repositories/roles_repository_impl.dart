import 'package:fundingrate/src/data/datasources/roles_local_data_source.dart';
import 'package:fundingrate/src/domain/entities/user.dart';
import 'package:fundingrate/src/domain/repositories/roles_repository.dart';
import 'package:dotenv/dotenv.dart';

class RolesRepositoryImpl implements RolesRepository {
  final RolesLocalDataSource localDataSource;
  final DotEnv env;
  late Map<String, String> _roles;

  RolesRepositoryImpl({required this.localDataSource, required this.env});

  @override
  Future<void> init() async {
    _roles = await localDataSource.getRoles();
    final superAdmins = env['SUPER_ADMINS']?.split(',') ?? [];
    var updated = false;
    for (final adminId in superAdmins) {
      if (_roles[adminId.trim()] != 'admin') {
        _roles[adminId.trim()] = 'admin';
        updated = true;
      }
    }
    if (updated) {
      await localDataSource.saveRoles(_roles);
    }
  }

  @override
  Future<void> addRole(int userId, UserRole role) async {
    _roles[userId.toString()] = role.name;
    await localDataSource.saveRoles(_roles);
  }

  @override
  Future<List<int>> getAdminIds() async {
    return _roles.entries
        .where((entry) => entry.value == 'admin')
        .map((entry) => int.parse(entry.key))
        .toList();
  }

  @override
  Future<List<int>> getModeratorIds() async {
    return _roles.entries
        .where((entry) => entry.value == 'moderator')
        .map((entry) => int.parse(entry.key))
        .toList();
  }

  @override
  Future<UserRole?> getRole(int userId) async {
    final roleString = _roles[userId.toString()];
    return UserRole.fromString(roleString);
  }

  @override
  Future<void> removeRole(int userId, UserRole role) async {
    if (_roles[userId.toString()] == role.name) {
      _roles.remove(userId.toString());
      await localDataSource.saveRoles(_roles);
    }
  }
}
