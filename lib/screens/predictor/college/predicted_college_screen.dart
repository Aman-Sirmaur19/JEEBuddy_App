import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/college_data.dart';
import '../../../widgets/custom_banner_ad.dart';
import '../../../widgets/custom_popup_selector.dart';

class PredictedCollegeScreen extends StatefulWidget {
  final List<CollegeData> predictedColleges;

  const PredictedCollegeScreen({super.key, required this.predictedColleges});

  @override
  State<PredictedCollegeScreen> createState() => _PredictedCollegeScreenState();
}

class _PredictedCollegeScreenState extends State<PredictedCollegeScreen> {
  final List<String> _selectedCollegeTypes = []; // ['IIT', 'NIT', etc.]
  String? _sortBy; // 'OR_ASC', 'OR_DESC', 'CR_ASC', 'CR_DESC'

  List<CollegeData> get _filteredColleges {
    List<CollegeData> filtered = widget.predictedColleges.where((college) {
      final type = _getCollegeType(college.institute);
      return _selectedCollegeTypes.isEmpty ||
          _selectedCollegeTypes.contains(type);
    }).toList();

    if (_sortBy == 'Opening Rank ↑') {
      filtered.sort((a, b) => a.openingRank.compareTo(b.openingRank));
    } else if (_sortBy == 'Opening Rank ↓') {
      filtered.sort((a, b) => b.openingRank.compareTo(a.openingRank));
    } else if (_sortBy == 'Closing Rank ↑') {
      filtered.sort((a, b) => a.closingRank.compareTo(b.closingRank));
    } else if (_sortBy == 'Closing Rank ↓') {
      filtered.sort((a, b) => b.closingRank.compareTo(a.closingRank));
    }

    return filtered;
  }

  String _getCollegeType(String name) {
    name = name.toLowerCase();
    if (name.contains('indian institute of technology')) return 'IIT';
    if (name.contains('national institute of technology')) return 'NIT';
    if (name.contains('information')) return 'IIIT';
    return 'GFTI';
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final Map<String, int> availableTypesWithCount = {};
            for (var college in widget.predictedColleges) {
              final name = college.institute.toLowerCase();
              String type;
              if (name.contains('indian institute of technology')) {
                type = 'IIT';
              } else if (name.contains('national institute of technology')) {
                type = 'NIT';
              } else if (name.contains('information')) {
                type = 'IIIT';
              } else {
                type = 'GFTI';
              }
              availableTypesWithCount[type] =
                  (availableTypesWithCount[type] ?? 0) + 1;
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Filter Colleges',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('College Types',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: availableTypesWithCount.entries.map((entry) {
                      final type = entry.key;
                      final count = entry.value;
                      final isSelected = _selectedCollegeTypes.contains(type);
                      return FilterChip(
                        label: Text('$type ($count)'),
                        selected: isSelected,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: isSelected ? Colors.orange : Colors.grey),
                        ),
                        selectedColor: Colors.orange,
                        onSelected: (selected) {
                          setSheetState(() {
                            isSelected
                                ? _selectedCollegeTypes.remove(type)
                                : _selectedCollegeTypes.add(type);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Sort By',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  CustomPopupSelector(
                    title: 'Choose Sort By',
                    selectedValue: _sortBy ?? 'Choose Sort By',
                    options: const [
                      'Choose Sort By',
                      'Opening Rank ↑',
                      'Opening Rank ↓',
                      'Closing Rank ↑',
                      'Closing Rank ↓',
                    ],
                    onSelected: (value) {
                      setSheetState(() {
                        _sortBy = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Refresh UI with filters
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          title: const Text('Predicted Colleges'),
          actions: [
            IconButton(
              onPressed: _showFilterSheet,
              tooltip: 'Filters',
              icon: const Icon(Icons.filter_alt_rounded),
            )
          ],
        ),
        bottomNavigationBar: const CustomBannerAd(),
        body: _filteredColleges.isEmpty
            ? const Center(child: Text('No colleges found'))
            : ListView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                itemCount: _filteredColleges.length,
                itemBuilder: (context, index) {
                  final college = _filteredColleges[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey, width: .5),
                          borderRadius: BorderRadius.circular(15)),
                      title: Text(
                        college.institute,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            college.program,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(color: Colors.grey, thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _customText(
                                title: 'OR: ',
                                value: '${college.openingRank}',
                                color: Colors.lightGreen,
                              ),
                              _customText(
                                title: 'CR: ',
                                value: '${college.closingRank}',
                                color: Colors.redAccent,
                              ),
                              _customText(
                                title: 'Quota: ',
                                value: college.quota != 'AI' &&
                                        college.quota != 'OS'
                                    ? 'HS'
                                    : college.quota,
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _customText(
                                title: 'Category: ',
                                value: college.seatType,
                                color: Colors.cyan,
                              ),
                              _customText(
                                title: 'College Type: ',
                                value: college.institute.toLowerCase().contains(
                                        'national institute of technology')
                                    ? 'NIT'
                                    : college.institute.toLowerCase().contains(
                                            'indian institute of technology')
                                        ? 'IIT'
                                        : college.institute
                                                .toLowerCase()
                                                .contains('information')
                                            ? 'IIIT'
                                            : 'GFTI',
                                color: Colors.pinkAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _customText({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                color: color,
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
