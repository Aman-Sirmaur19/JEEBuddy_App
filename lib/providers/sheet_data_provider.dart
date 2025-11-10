import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

import '../secrets.dart';

class SheetDataProvider with ChangeNotifier {
  final Map<String, String> sheetUrls = {
    "Notes": Secrets.notesUrl,
    "Lectures": Secrets.lecturesUrl,
    "PYQs": Secrets.pyqUrl,
  };

  final Map<String, List<List<dynamic>>> _cache = {};
  final Map<String, bool> _loading = {};
  final Map<String, String?> _errors = {};

  Map<String, List<List<dynamic>>> get cache => _cache;

  bool isLoading(String sheet) => _loading[sheet] ?? false;

  String? error(String sheet) => _errors[sheet];

  Future<List<List<dynamic>>?> loadSheet(String sheetName) async {
    if (_cache.containsKey(sheetName)) {
      return _cache[sheetName]; // already loaded
    }
    if (_loading[sheetName] == true) return null; // already in progress

    final url = sheetUrls[sheetName];
    if (url == null) {
      _errors[sheetName] = "Unknown sheet: $sheetName";
      notifyListeners();
      return null;
    }

    _loading[sheetName] = true;
    _errors[sheetName] = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = const CsvToListConverter(eol: '\n').convert(response.body);
        _cache[sheetName] = data;
      } else {
        _errors[sheetName] =
            'Failed to load $sheetName (HTTP ${response.statusCode})';
      }
    } catch (e, st) {
      print('CSV parse error for $sheetName: $e\n$st');
      _errors[sheetName] = e.toString();
    } finally {
      _loading[sheetName] = false;
      notifyListeners();
    }

    return null;
  }

  Future<List<List<dynamic>>?> refreshSheet(String sheetName) async {
    _cache.remove(sheetName);
    return loadSheet(sheetName);
  }
}
