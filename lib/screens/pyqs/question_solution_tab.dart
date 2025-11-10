import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_banner_ad.dart';
import '../../providers/sheet_data_provider.dart';
import 'pyq_viewer.dart';

class QuestionSolutionTab extends StatefulWidget {
  final String examLabel;
  final String year;
  final String label;

  const QuestionSolutionTab({
    super.key,
    required this.examLabel,
    required this.year,
    required this.label,
  });

  @override
  State<QuestionSolutionTab> createState() => _QuestionSolutionTabState();
}

class _QuestionSolutionTabState extends State<QuestionSolutionTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? questionPaperUrl;
  String? solutionUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    final provider = Provider.of<SheetDataProvider>(context, listen: false);
    final rows = provider.cache['PYQs']!.skip(1); // Skip header

    for (var row in rows) {
      if (row.length < 6) continue;

      final bottomTab = row[0]?.toString().trim() ?? '';
      final tab = row[1]?.toString().trim() ?? '';
      final section = row[2]?.toString().trim() ?? '';
      final subSection = row[3]?.toString().trim() ?? '';
      final name = row[4]?.toString().trim() ?? '';
      final url = row[5]?.toString().trim() ?? '';

      if (bottomTab == 'PYQs' &&
          tab == widget.examLabel &&
          section == widget.year &&
          subSection == widget.label &&
          subSection.isNotEmpty) {
        questionPaperUrl = name;
        solutionUrl = url;
        break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questionPaperUrl == null && solutionUrl == null) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('${widget.label} - ${widget.year}')),
          bottomNavigationBar: const CustomBannerAd(),
          body: const Center(child: Text('No data available')),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          title: Text(
            '${widget.label} (${widget.year})',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        bottomNavigationBar: const CustomBannerAd(),
        body: Column(
          children: [
            Container(
              height: 30,
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(5),
                ),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(3),
                labelColor: Colors.orange,
                labelPadding: EdgeInsets.zero,
                // Unselected text color
                tabs: const [
                  Tab(text: 'Question Paper'),
                  Tab(text: 'Solution')
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PYQViewer(
                      pdfName: 'Question Paper', pdfUrl: questionPaperUrl!),
                  PYQViewer(pdfName: 'Solution', pdfUrl: solutionUrl!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
