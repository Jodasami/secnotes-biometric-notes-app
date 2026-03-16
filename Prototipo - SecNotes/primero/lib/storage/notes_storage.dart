import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesStorage {

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notes.json');
  }

  Future<void> saveNotes(List<Map<String, dynamic>> notes) async {
    final file = await _getFile();
    String jsonData = JsonEncoder.withIndent('  ').convert(notes);
    await file.writeAsString(jsonData);
  }

  Future<List<Map<String, dynamic>>> loadNotes() async {
    try {
      final file = await _getFile();

      if (!await file.exists()) {
        return [];
      }

      String contents = await file.readAsString();
      List data = jsonDecode(contents);

      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}