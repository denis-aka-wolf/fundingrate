import '../repositories/user_settings_repository.dart';

class GetAllUserIds {
  final UserSettingsRepository repository;

  GetAllUserIds(this.repository);

  Future<List<String>> call() {
    return repository.getAllUserIds();
  }
}