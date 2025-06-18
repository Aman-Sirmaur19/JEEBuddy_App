import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_update/in_app_update.dart';

import '../services/ad_manager.dart';
import '../providers/sheet_data_provider.dart';
import '../providers/college_data_provider.dart';
import 'dashboard_screen.dart';
import 'pyqs/pyqs_tab_screen.dart';
import 'notes/notes_tab_screen.dart';
import 'predictor/predictor_screen.dart';
import 'lectures/lectures_tab_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late List<Map<String, dynamic>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
    Future.delayed(Duration.zero, () {
      Provider.of<SheetDataProvider>(context, listen: false).loadData();
      Provider.of<CollegeDataProvider>(context, listen: false).loadAllCsv();
    });
    _pages = [
      {'page': const PredictorScreen()},
      {'page': const NotesTabScreen()},
      {'page': const LecturesTabScreen()},
      {'page': const PYQsTabScreen()},
    ];
  }

  Future<void> _checkForUpdate() async {
    await InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          _update();
        }
      });
    }).catchError((error) {});
  }

  void _update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {});
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
              text: TextSpan(
            text: 'JEE',
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 1,
              color: Colors.orange,
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w900,
            ),
            children: [
              TextSpan(
                text: 'Buddy',
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 0,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          )),
          actions: [
            IconButton(
              onPressed: () =>
                  AdManager().navigateWithAd(context, const DashboardScreen()),
              tooltip: 'Dashboard',
              icon: const Icon(CupertinoIcons.square_grid_2x2),
            ),
          ],
        ),
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_alt_outlined),
              label: 'Predictor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ondemand_video_rounded),
              label: 'Lectures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: 'PYQs',
            ),
          ],
        ),
      ),
    );
  }
}
