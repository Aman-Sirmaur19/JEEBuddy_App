import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ad_manager.dart';
import '../../widgets/custom_banner_ad.dart';
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

    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.orange));
    }

    if (provider.error != null) {
      return Center(child: Text('Failed to load shifts: ${provider.error}'));
    }

    final rows = provider.data.skip(1);
    final Set<String> shifts = {};

    for (var row in rows) {
      if (row.length < 5) continue;

      final bottomTab = row[1]?.toString().trim() ?? '';
      final tab = row[2]?.toString().trim() ?? '';
      final section = row[3]?.toString().trim() ?? ''; // year
      final subSection = row[4]?.toString().trim() ?? ''; // shift

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
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    )),
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
