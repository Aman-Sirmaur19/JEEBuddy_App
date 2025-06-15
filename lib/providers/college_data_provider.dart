import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '../models/college_data.dart';

class CollegeDataProvider with ChangeNotifier {
  List<CollegeData> _allData = [];

  List<CollegeData> get allData => _allData;

  Future<void> loadAllCsv() async {
    try {
      final rawCsv = await rootBundle.loadString('assets/data/2024.csv');
      final rows = const CsvToListConverter().convert(rawCsv, eol: '\n');

      if (rows.length <= 1) return;

      final dataRows =
          rows.skip(1).map((row) => CollegeData.fromCsvRow(row)).toList();

      _allData = dataRows;
      notifyListeners();
    } catch (e) {
      debugPrint('CSV load error: $e');
    }
  }

  /// Filter based on exam type
  List<CollegeData> getFilteredData(String exam) {
    return _allData.where((row) {
      final isIIT = row.institute.startsWith('Indian Institute of Technology');
      final isArchitecture = row.program.toLowerCase().contains('architecture');

      if (exam == 'Advanced') return isIIT;
      if (exam == 'B.Arch') return !isIIT && isArchitecture;
      return !isIIT && !isArchitecture; // B.Tech case
    }).toList();
  }

  List<String> _unique(String Function(CollegeData) keySelector, String exam) {
    final data = getFilteredData(exam);
    return data.map(keySelector).toSet().toList()..sort();
  }

  List<String> getRounds(String exam) =>
      ['Choose Round', ..._unique((e) => e.round, exam)];

  List<String> getStates(String exam) {
    final rawQuotas = _unique((e) => e.quota, exam);
    final stateQuotas = rawQuotas.where((q) => q != 'AI' && q != 'OS').toList();
    return ['Choose Home State', ...stateQuotas];
  }

  List<String> getGenders(String exam) =>
      ['Choose Gender', ..._unique((e) => e.gender, exam)];

  List<String> getCategories(String exam) =>
      ['Choose Category', ..._unique((e) => e.seatType, exam)];

  List<String> getBranches(String exam) =>
      ['Choose Branch', ..._unique((e) => e.program, exam)];

  List<String> getColleges(String exam) =>
      ['Choose College', ..._unique((e) => e.institute, exam)];

  List<CollegeData> filterBy({
    required String exam,
    String? round,
    String? homeState,
    String? gender,
    String? category,
    String? branch,
    int? rank,
  }) {
    final data = getFilteredData(exam);

    final filtered = data.where((entry) {
      final isHomeStateCollege = entry.quota == homeState;
      final isOtherStateQuota = entry.quota == 'AI' || entry.quota == 'OS';

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
