import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

class SheetDataProvider with ChangeNotifier {
  List<List<dynamic>> _data = [];
  bool _isLoaded = false;
  bool _isLoading = false;
  String? _error;

  List<List<dynamic>> get data => _data;

  bool get isLoaded => _isLoaded;

  bool get isLoading => _isLoading;

  String? get error => _error;

  static const String csvUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vQN9DwnvdtZAFTnj1MnxjBaWElgMlKCdKZpQz4Mgive8CETibnWJoNPBaMqFMmWIfyMfM-2udrXV7SW/pub?output=csv';

  Future<void> loadData() async {
    if (_isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(csvUrl));
      if (response.statusCode == 200) {
        _data = const CsvToListConverter(eol: '\n').convert(response.body);
        _isLoaded = true;
      } else {
        _error = 'Failed to load sheet';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(csvUrl));
      if (response.statusCode == 200) {
        _data = const CsvToListConverter(eol: '\n').convert(response.body);
        _isLoaded = true;
      } else {
        _error = 'Failed to reload sheet';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
