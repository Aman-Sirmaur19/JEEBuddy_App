import 'package:flutter/material.dart';

import '../../services/ad_manager.dart';
import '../../widgets/custom_banner_ad.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/percentile_rank_range.dart';
import 'college/college_predictor_screen.dart';

class PredictorScreen extends StatelessWidget {
  const PredictorScreen({super.key});

  void _showPredictionSheet(BuildContext context, String title) {
    final TextEditingController percentileController = TextEditingController();
    String? predictedRank;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title == 'Percentile'
                          ? '$title  ~~>  Rank'
                          : '$title  ~~>  Percentile',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: percentileController,
                      isNum: true,
                      hintText: 'Enter $title',
                      onFieldSubmitted: (_) {
                        final input =
                            double.tryParse(percentileController.text);
                        if (title == 'Percentile') {
                          if (input != null && input >= 0 && input <= 100) {
                            final rank = percentileToRank(input);
                            setModalState(() {
                              predictedRank = rank != null
                                  ? 'Your predicted rank is approximately $rank'
                                  : 'Percentile out of supported range';
                            });
                          }
                        } else {
                          final rank = input?.toInt();
                          if (rank != null && rank >= 1) {
                            final percentile = rankToPercentile(rank);
                            setModalState(() {
                              predictedRank = percentile != null
                                  ? 'Your predicted percentile is approximately $percentile'
                                  : 'Rank out of supported range';
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    if (predictedRank != null)
                      Text(
                        predictedRank!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        final input =
                            double.tryParse(percentileController.text);
                        if (title == 'Percentile') {
                          if (input != null && input >= 0 && input <= 100) {
                            final rank = percentileToRank(input);
                            setModalState(() {
                              predictedRank = rank != null
                                  ? 'Your predicted rank is approximately $rank'
                                  : 'Percentile out of supported range';
                            });
                          }
                        } else {
                          final rank = input?.toInt();
                          if (rank != null && rank >= 1) {
                            final percentile = rankToPercentile(rank);
                            setModalState(() {
                              predictedRank = percentile != null
                                  ? 'Your predicted percentile is approximately $percentile'
                                  : 'Rank out of supported range';
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.psychology_alt_outlined),
                      label: Text(
                          'Predict ${title == 'Rank' ? 'Percentile' : 'Rank'}'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBannerAd(),
      body: ListView(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        children: [
          const Text(
            'Percentile / Rank Predictor',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          _customListTile(
            context: context,
            onTap: () => _showPredictionSheet(context, 'Percentile'),
            title: 'JEE Mains',
            subtitle: 'Percentile  ~~>  Rank',
            icon: Icons.insights_rounded,
          ),
          const SizedBox(height: 10),
          _customListTile(
            context: context,
            onTap: () => _showPredictionSheet(context, 'Rank'),
            title: 'JEE Mains',
            subtitle: 'Rank  ~~>  Percentile',
            icon: Icons.percent_rounded,
          ),
          const SizedBox(height: 30),
          const Text(
            'College Predictor',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          _customListTile(
            context: context,
            onTap: () => AdManager().navigateWithAd(
                context, const CollegePredictorScreen(exam: 'B.Tech')),
            title: 'JEE Mains - B.Tech',
            subtitle: 'NITs, IIITs & GFTIs',
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 10),
          _customListTile(
            context: context,
            onTap: () => AdManager().navigateWithAd(
                context, const CollegePredictorScreen(exam: 'B.Arch')),
            title: 'JEE Mains - B.Arch',
            subtitle: 'NITs & GFTIs',
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 10),
          _customListTile(
            context: context,
            onTap: () => AdManager().navigateWithAd(
                context, const CollegePredictorScreen(exam: 'Advanced')),
            title: 'JEE Advanced',
            subtitle: 'IITs',
            icon: Icons.school_outlined,
          ),
        ],
      ),
    );
  }

  Widget _customListTile({
    required BuildContext context,
    required void Function() onTap,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle,
          style: TextStyle(
            letterSpacing: .5,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          )),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }
}
