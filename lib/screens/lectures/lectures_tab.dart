import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sheet_data_provider.dart';
import '../../widgets/custom_grid_view.dart';
import '../../widgets/internet_connectivity_button.dart';

class LecturesTab extends StatelessWidget {
  final String subject;

  const LecturesTab({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.orange));
    }

    if (provider.error != null) {
      return InternetConnectivityButton(
          onPressed: () =>
              Future.delayed(Duration.zero, () => provider.loadData()));
    }

    final data = provider.data;
    final rows = data.skip(1); // Skip header

    final Map<String, Set<String>> sectionsBySubject = {
      'Lectures': {},
      'One Shots': {},
    };

    for (var row in rows) {
      if (row.length < 5) continue;

      final bottomTab = row[1]?.toString().trim() ?? '';
      final tab = row[2]?.toString().trim() ?? '';
      final section = row[3]?.toString().trim() ?? '';
      final subSection = row[4]?.toString().trim() ?? '';

      if (bottomTab == 'Lectures' && tab == subject && subSection.isNotEmpty) {
        if (sectionsBySubject.containsKey(section)) {
          sectionsBySubject[section]!.add(subSection);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      children: [
        _buildSection(
            'Lectures', sectionsBySubject['Lectures'] ?? {}, provider),
        const SizedBox(height: 30),
        _buildSection(
            'One Shots', sectionsBySubject['One Shots'] ?? {}, provider),
      ],
    );
  }

  Widget _buildSection(
      String title, Set<String> authors, SheetDataProvider provider) {
    final filteredAuthors = authors.where((e) => e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        CustomGridView(
            label: title, items: filteredAuthors, provider: provider),
      ],
    );
  }
}
