import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sheet_data_provider.dart';
import '../../widgets/internet_connectivity_button.dart';
import 'shifts_screen.dart';

class PYQsTab extends StatelessWidget {
  final String label;

  const PYQsTab({super.key, required this.label});

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
    final rows = data.skip(1); // skip header

    final Set<String> years = {};

    for (var row in rows) {
      if (row.length < 5) continue;

      final bottomTab = row[1]?.toString().trim() ?? '';
      final tab = row[2]?.toString().trim() ?? '';
      final section = row[3]?.toString().trim() ?? '';

      if (bottomTab == 'PYQs' && tab == label && section.isNotEmpty) {
        years.add(section); // section is the year (e.g., 2025, 2024)
      }
    }

    final sortedYears = years.toList()..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: sortedYears.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ShiftsScreen(
                  year: sortedYears[index],
                  examLabel: label,
                ),
              ),
            ),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(sortedYears[index]),
            trailing:
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ),
        );
      },
    );
  }
}
