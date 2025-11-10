import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/college_data.dart';

class CollegeDataProvider with ChangeNotifier {
  final Map<String, List<CollegeData>> _dataByYear = {};

  List<CollegeData> getData(String year) => _dataByYear[year] ?? [];

  Future<void> loadAllCsv() async {
    try {
      final csvFiles = {
        '2024': 'assets/data/2024.csv',
        '2025': 'assets/data/2025.csv',
      };

      for (final entry in csvFiles.entries) {
        final rawCsv = await rootBundle.loadString(entry.value);
        final rows = const CsvToListConverter().convert(rawCsv, eol: '\n');

        if (rows.length <= 1) continue;

        final dataRows =
            rows.skip(1).map((row) => CollegeData.fromCsvRow(row)).toList();

        _dataByYear[entry.key] = dataRows;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('CSV load error: $e');
    }
  }

  /// Filter based on exam type + year
  List<CollegeData> getFilteredData(String exam, String year) {
    final data = getData(year);

    return data.where((row) {
      final isIIT = row.institute.startsWith('Indian Institute of Technology');
      final isArchitecture = row.program.toLowerCase().contains('architecture');

      if (exam == 'Advanced') return isIIT;
      if (exam == 'B.Arch') return !isIIT && isArchitecture;
      return !isIIT && !isArchitecture; // B.Tech case
    }).toList();
  }

  List<String> _unique(
      String Function(CollegeData) keySelector, String exam, String year) {
    final data = getFilteredData(exam, year);
    return data.map(keySelector).toSet().toList()..sort();
  }

  List<String> getRounds(String exam, String year) =>
      ['Choose Round', ..._unique((e) => e.round, exam, year)];

  List<String> getStates(String exam, String year) {
    final rawQuotas = _unique((e) => e.quota, exam, year);
    final stateQuotas = rawQuotas
        .where((q) =>
            q != 'AI' && q != 'OS' && q != 'All India' && q != 'Other State')
        .toList();
    return ['Choose Home State', ...stateQuotas];
  }

  List<String> getGenders(String exam, String year) =>
      ['Choose Gender', ..._unique((e) => e.gender, exam, year)];

  List<String> getCategories(String exam, String year) =>
      ['Choose Category', ..._unique((e) => e.seatType, exam, year)];

  List<String> getBranches(String exam, String year) =>
      ['Choose Branch', ..._unique((e) => e.program, exam, year)];

  List<String> getColleges(String exam, String year) =>
      ['Choose College', ..._unique((e) => e.institute, exam, year)];

  List<CollegeData> filterBy({
    required String exam,
    required String year,
    String? round,
    String? homeState,
    String? gender,
    String? category,
    String? branch,
    int? rank,
  }) {
    final data = getFilteredData(exam, year);

    final filtered = data.where((entry) {
      final isHomeStateCollege = entry.quota == homeState;
      final isOtherStateQuota = entry.quota == 'AI' ||
          entry.quota == 'OS' ||
          entry.quota == 'All India' ||
          entry.quota == 'Other State';

      final applyRankFilter = rank == null ||
          ((homeState == null || homeState == 'Choose Home State') &&
              entry.closingRank >= rank) ||
          ((homeState != null && homeState != 'Choose Home State') &&
              ((isHomeStateCollege && entry.closingRank >= rank) ||
                  (isOtherStateQuota && entry.closingRank >= rank)));

      return (round == null ||
              round == 'Choose Round' ||
              entry.round == round) &&
          (gender == null ||
              gender == 'Choose Gender' ||
              entry.gender == gender) &&
          (category == null ||
              category == 'Choose Category' ||
              entry.seatType == category) &&
          (branch == null ||
              branch == 'Choose Branch' ||
              entry.program == branch) &&
          applyRankFilter;
    }).toList();

    // Sort by opening rank ascending
    filtered.sort((a, b) => a.openingRank.compareTo(b.openingRank));
    return filtered;
  }
}
