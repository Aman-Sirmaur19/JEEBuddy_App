import 'package:flutter/material.dart';

import 'notes_tab.dart';

class NotesTabScreen extends StatefulWidget {
  const NotesTabScreen({super.key});

  @override
  State<NotesTabScreen> createState() => _NotesTabScreenState();
}

class _NotesTabScreenState extends State<NotesTabScreen>
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
              Tab(text: "Notes"),
              Tab(text: "Sheets"),
              Tab(text: "Books"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              NotesTab(label: 'Notes'),
              NotesTab(label: 'Sheets'),
              NotesTab(label: 'Books'),
            ],
          ),
        ),
      ],
    );
  }
}
