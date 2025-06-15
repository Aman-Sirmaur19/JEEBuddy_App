import 'package:flutter/material.dart';

import 'lectures_tab.dart';

class LecturesTabScreen extends StatefulWidget {
  const LecturesTabScreen({super.key});

  @override
  State<LecturesTabScreen> createState() => _LecturesTabScreenState();
}

class _LecturesTabScreenState extends State<LecturesTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            labelColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: const EdgeInsets.all(0),
            indicatorPadding: const EdgeInsets.all(3),
            // Unselected text color
            tabs: const [
              Tab(text: "Physics"),
              Tab(text: "Chemistry"),
              Tab(text: "Maths"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              LecturesTab(subject: 'Physics'),
              LecturesTab(subject: 'Chemistry'),
              LecturesTab(subject: 'Maths'),
            ],
          ),
        ),
      ],
    );
  }
}
