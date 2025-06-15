import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_popup_selector.dart';
import '../../../providers/college_data_provider.dart';
import 'predicted_college_screen.dart';

class CollegePredictorScreen extends StatefulWidget {
  final String exam;

  const CollegePredictorScreen({super.key, required this.exam});

  @override
  State<CollegePredictorScreen> createState() => _CollegePredictorScreenState();
}

class _CollegePredictorScreenState extends State<CollegePredictorScreen> {
  final TextEditingController _rankController = TextEditingController();
  String _round = 'Choose Round';
  String _quota = 'Choose Home State';
  String _category = 'Choose Category';
  String _gender = 'Choose Gender';
  String _branch = 'Choose Branch';
  String _college = 'Choose College';

  @override
  void dispose() {
    _rankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<CollegeDataProvider>(context);
    final exam = widget.exam; // "Advanced", "B.Tech", "B.Arch"
    final rounds = dataProvider.getRounds(exam);
    final quotas = dataProvider.getStates(exam);
    final genders = dataProvider.getGenders(exam);
    final categories = dataProvider.getCategories(exam);
    final branches = dataProvider.getBranches(exam);
    final colleges = dataProvider.getColleges(exam);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
              icon: const Icon(CupertinoIcons.chevron_back),
            ),
            title: const Text('College Predictor'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      if (widget.exam != 'Advanced') ...[
                        CustomPopupSelector(
                          title: 'Choose Home State',
                          selectedValue: _quota,
                          options: quotas,
                          onSelected: (value) {
                            setState(() {
                              _quota = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomPopupSelector(
                          title: 'Choose Round',
                          selectedValue: _round,
                          options: rounds,
                          onSelected: (value) {
                            setState(() {
                              _round = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      CustomPopupSelector(
                        title: 'Choose Category',
                        selectedValue: _category,
                        options: categories,
                        onSelected: (value) {
                          setState(() {
                            _category = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Enter your ${_round.contains('CSAB') ? 'All India' : 'Category'} Rank',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomTextField(
                        controller: _rankController,
                        isNum: true,
                        hintText: _round.contains('CSAB')
                            ? 'All India Rank'
                            : 'Category Rank',
                        onFieldSubmitted: (_) {},
                      ),
                      const SizedBox(height: 20),
                      CustomPopupSelector(
                        title: genders.isEmpty ? 'Loading…' : 'Choose Gender',
                        selectedValue: _gender,
                        options: genders,
                        onSelected: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      // const SizedBox(height: 20),
                      // if (widget.exam != 'B.Arch') ...[
                      //   CustomPopupSelector(
                      //     title: branches.isEmpty ? 'Loading…' : 'Choose Branch',
                      //     selectedValue: _branch,
                      //     options: branches,
                      //     onSelected: (value) {
                      //       setState(() {
                      //         _branch = value;
                      //       });
                      //     },
                      //   ),
                      //   const SizedBox(height: 20),
                      // ],
                      // CustomPopupSelector(
                      //   title: colleges.isEmpty ? 'Loading…' : 'Choose College',
                      //   selectedValue: _college,
                      //   options: colleges,
                      //   onSelected: (value) {
                      //     setState(() {
                      //       _college = value;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final predictedList = dataProvider.filterBy(
                        exam: widget.exam,
                        round: _round,
                        homeState: _quota,
                        gender: _gender,
                        category: _category,
                        branch: _branch,
                        rank: int.tryParse(_rankController.text.trim()),
                      );
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => PredictedCollegeScreen(
                                  predictedColleges: predictedList)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.school_outlined),
                    label: const Text('Predict College'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
