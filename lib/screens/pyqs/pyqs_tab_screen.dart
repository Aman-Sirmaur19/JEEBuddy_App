import 'package:flutter/material.dart';

import 'pyqs_tab.dart';

class PYQsTabScreen extends StatefulWidget {
  const PYQsTabScreen({super.key});

  @override
  State<PYQsTabScreen> createState() => _PYQsTabScreenState();
}

class _PYQsTabScreenState extends State<PYQsTabScreen>
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
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(3),
            labelColor: Colors.orange,
            labelPadding: EdgeInsets.zero,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            // Unselected text color
            tabs: const [
              Tab(text: "JEE Mains - B.Tech"),
              Tab(text: "JEE Mains - B.Arch"),
              Tab(text: "JEE Advanced"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              PYQsTab(label: "JEE Mains - B.Tech"),
              PYQsTab(label: "JEE Mains - B.Arch"),
              PYQsTab(label: "JEE Advanced"),
            ],
          ),
        ),
      ],
    );
  }
}
