import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

abstract class JsonLocalDataSource<T> {
  Future<T?> get(String id);
  Future<void> save(String id, T data);
  Future<void> delete(String id);
  Future<List<String>> getAllIds();
}

class JsonLocalDataSourceImpl<T> implements JsonLocalDataSource<T> {
  final Directory directory;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T data) toJson;

  JsonLocalDataSourceImpl({
    required String directoryPath,
    required this.fromJson,
    required this.toJson,
  }) : directory = Directory(directoryPath) {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  File _getFile(String id) {
    return File(path.join(directory.path, '$id.json'));
  }

  @override
  Future<T?> get(String id) async {
    final file = _getFile(id);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      if (jsonString.isNotEmpty) {
        try {
          return fromJson(jsonDecode(jsonString));
        } catch (e) {
          // Handle malformed JSON
          return null;
        }
      }
    }
    return null;
  }

  @override
  Future<void> save(String id, T data) async {
    final file = _getFile(id);
    await file.writeAsString(jsonEncode(toJson(data)));
  }

  @override
  Future<void> delete(String id) async {
    final file = _getFile(id);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<String>> getAllIds() async {
    if (!await directory.exists()) {
      return [];
    }
    final files = await directory.list().toList();
    return files
        .where((file) => file is File && path.extension(file.path) == '.json')
        .map((file) => path.basenameWithoutExtension(file.path))
        .toList();
  }
}