import 'dart:io';

class FileEntity {
  FileEntity(this._path, this._file);

  final String _path;
  final File _file;

  String get path => _path;

  List<String> readAsLinesSync() {
    return _file.readAsLinesSync();
  }
}
