import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sheet_data_provider.dart';
import '../../widgets/custom_banner_ad.dart';
import '../../widgets/custom_grid_view.dart';
import '../../widgets/internet_connectivity_button.dart';

class LecturesTab extends StatefulWidget {
  final String subject;

  const LecturesTab({super.key, required this.subject});

  @override
  State<LecturesTab> createState() => _LecturesTabState();
}

class _LecturesTabState extends State<LecturesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SheetDataProvider>(context, listen: false);
      if (provider.cache["Lectures"] == null) {
        provider.loadSheet("Lectures");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    final data = provider.cache["Lectures"];
    final isLoading = provider.isLoading("Lectures");
    final error = provider.error("Lectures");

    // Loading state
    if (isLoading && data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    // Error state
    if (error != null && data == null) {
      return InternetConnectivityButton(
        onPressed: () => provider.refreshSheet("Lectures"),
      );
    }

    // No data yet but no error → show spinner
    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    // ✅ Now we have data
    final rows = data.skip(1); // skip header
    final Map<String, Set<String>> sectionsBySubject = {
      'Lectures': {},
      'One Shots': {},
    };

    for (var row in rows) {
      if (row.length < 4) continue;

      final bottomTab = row[0]?.toString().trim() ?? '';
      final tab = row[1]?.toString().trim() ?? '';
      final section = row[2]?.toString().trim() ?? '';
      final subSection = row[3]?.toString().trim() ?? '';

      if (bottomTab == 'Lectures' &&
          tab == widget.subject &&
          subSection.isNotEmpty) {
        if (sectionsBySubject.containsKey(section)) {
          sectionsBySubject[section]!.add(subSection);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      children: [
        const CustomBannerAd(),
        _buildSection('Lectures', sectionsBySubject['Lectures'] ?? {}),
        const SizedBox(height: 30),
        _buildSection('One Shots', sectionsBySubject['One Shots'] ?? {}),
      ],
    );
  }

  Widget _buildSection(String title, Set<String> authors) {
    final filteredAuthors = authors.where((e) => e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        CustomGridView(
          label: 'Lectures',
          subLabel: title == 'One Shots' ? 'One Shots' : null,
          items: filteredAuthors,
        ),
      ],
    );
  }
}
