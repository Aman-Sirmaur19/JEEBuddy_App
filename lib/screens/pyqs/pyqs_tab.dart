import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ad_manager.dart';
import '../../providers/sheet_data_provider.dart';
import '../../widgets/internet_connectivity_button.dart';
import 'shifts_screen.dart';

class PYQsTab extends StatefulWidget {
  final String label;

  const PYQsTab({super.key, required this.label});

  @override
  State<PYQsTab> createState() => _PYQsTabState();
}

class _PYQsTabState extends State<PYQsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SheetDataProvider>(context, listen: false);
      if (provider.cache["PYQs"] == null) {
        provider.loadSheet("PYQs");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    final data = provider.cache["PYQs"];
    final isLoading = provider.isLoading("PYQs");
    final error = provider.error("PYQs");

    // Loading state
    if (isLoading && data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    // Error state
    if (error != null && data == null) {
      return InternetConnectivityButton(
        onPressed: () => provider.refreshSheet("PYQs"),
      );
    }

    // No data yet but no error → show spinner
    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    // ✅ We have data
    final rows = data.skip(1); // skip header
    final Set<String> years = {};

    for (var row in rows) {
      if (row.length < 4) continue;

      final bottomTab = row[0]?.toString().trim() ?? '';
      final tab = row[1]?.toString().trim() ?? '';
      final section = row[2]?.toString().trim() ?? '';

      if (bottomTab == 'PYQs' && tab == widget.label && section.isNotEmpty) {
        years.add(section); // e.g., 2025, 2024
      }
    }

    final sortedYears = years.toList()..sort((a, b) => b.compareTo(a));

    if (sortedYears.isEmpty) {
      return const Center(child: Text('No PYQs found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: sortedYears.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListTile(
            onTap: () => AdManager().navigateWithAd(
              context,
              ShiftsScreen(
                year: sortedYears[index],
                examLabel: widget.label,
              ),
            ),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(sortedYears[index]),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
