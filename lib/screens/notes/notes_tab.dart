import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sheet_data_provider.dart';
import '../../widgets/custom_banner_ad.dart';
import '../../widgets/custom_grid_view.dart';
import '../../widgets/internet_connectivity_button.dart';

class NotesTab extends StatefulWidget {
  final String label;

  const NotesTab({super.key, required this.label});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  @override
  void initState() {
    super.initState();

    // Trigger async loading safely after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SheetDataProvider>(context, listen: false);
      if (provider.cache["Notes"] == null) {
        provider.loadSheet("Notes");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    final data = provider.cache["Notes"];
    final isLoading = provider.isLoading("Notes");
    final error = provider.error("Notes");

    if (isLoading && data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    if (error != null && data == null) {
      return InternetConnectivityButton(
        onPressed: () => provider.refreshSheet("Notes"),
      );
    }

    if (data == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    final rows = data.skip(1);

    final Map<String, Set<String>> sectionsBySubject = {
      'Physics': {},
      'Chemistry': {},
      'Maths': {},
    };

    for (var row in rows) {
      if (row.length < 4) continue;

      final bottomTab = row[0]?.toString().trim() ?? '';
      final tab = row[1]?.toString().trim() ?? '';
      final section = row[2]?.toString().trim() ?? '';
      final subSection = row[3]?.toString().trim() ?? '';

      if (bottomTab == 'Notes' && tab == widget.label && subSection.isNotEmpty) {
        if (sectionsBySubject.containsKey(section)) {
          sectionsBySubject[section]!.add(subSection);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      children: [
        const CustomBannerAd(),
        _buildSection('Physics', sectionsBySubject['Physics'] ?? {}),
        const SizedBox(height: 30),
        _buildSection('Chemistry', sectionsBySubject['Chemistry'] ?? {}),
        const SizedBox(height: 30),
        _buildSection('Maths', sectionsBySubject['Maths'] ?? {}),
      ],
    );
  }

  Widget _buildSection(String subject, Set<String> authors) {
    final filteredAuthors = authors.where((e) => e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subject, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        CustomGridView(
          label: 'Notes',
          items: filteredAuthors,
        ),
      ],
    );
  }
}
