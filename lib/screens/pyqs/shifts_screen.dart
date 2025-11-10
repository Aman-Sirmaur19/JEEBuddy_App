import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ad_manager.dart';
import '../../widgets/custom_banner_ad.dart';
import '../../widgets/internet_connectivity_button.dart';
import '../../providers/sheet_data_provider.dart';
import 'question_solution_tab.dart';

class ShiftsScreen extends StatelessWidget {
  final String year;
  final String examLabel;

  const ShiftsScreen({
    super.key,
    required this.year,
    required this.examLabel,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    // Get cached data for PYQs
    final data = provider.cache["PYQs"];

    // Trigger lazy load if not available
    if (data == null && !provider.isLoading('PYQs')) {
      Future.delayed(Duration.zero, () => provider.loadSheet("PYQs"));
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    // Loading state
    if (provider.isLoading('PYQs') && data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    // Error state
    if (data == null) {
      return InternetConnectivityButton(
        onPressed: () => provider.refreshSheet("PYQs"),
      );
    }

    // At this point → we have PYQs data
    final rows = data.skip(1);
    final Set<String> shifts = {};

    for (var row in rows) {
      if (row.length < 4) continue;

      final bottomTab = row[0]?.toString().trim() ?? '';
      final tab = row[1]?.toString().trim() ?? '';
      final section = row[2]?.toString().trim() ?? ''; // year
      final subSection = row[3]?.toString().trim() ?? ''; // shift

      if (bottomTab == 'PYQs' &&
          tab == examLabel &&
          section == year &&
          subSection.isNotEmpty) {
        shifts.add(subSection);
      }
    }

    final sortedShifts = shifts.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('$examLabel ($year)'),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
        ),
        bottomNavigationBar: const CustomBannerAd(),
        body: sortedShifts.isEmpty
            ? const Center(child: Text('No Shifts Found'))
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: sortedShifts.length,
                itemBuilder: (context, index) {
                  final shift = sortedShifts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => AdManager().navigateWithAd(
                        context,
                        QuestionSolutionTab(
                          examLabel: examLabel,
                          year: year,
                          label: shift,
                        ),
                      ),
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(shift),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
