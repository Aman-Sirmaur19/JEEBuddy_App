import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ad_manager.dart';
import '../providers/sheet_data_provider.dart';
import '../screens/notes/pdfs_screen.dart';
import '../screens/lectures/playlists_screen.dart';
import '../screens/lectures/youtube_player_screen.dart';

class CustomGridView extends StatelessWidget {
  final String label;
  final String? subLabel;
  final List<String> items;

  const CustomGridView({
    super.key,
    required this.label,
    this.subLabel,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final title = items[index];
        return GestureDetector(
          onTap: () {
            final subSection = title;
            if (subLabel == null) {
              if (label == 'Notes') {
                AdManager().navigateWithAd(
                    context, PdfsScreen(sheetName: label, title: title));
              } else {
                AdManager().navigateWithAd(
                    context, PlaylistsScreen(title: subSection));
              }
            } else if (subLabel == 'One Shots') {
              final oneShotRow = provider.cache['Lectures']?.skip(1).firstWhere(
                    (row) => (row.length > 5 &&
                        row[2]?.toString().trim() == 'One Shots' &&
                        row[3]?.toString().trim() == subSection),
                    orElse: () => [],
                  );

              if (oneShotRow != null && oneShotRow.isNotEmpty) {
                final playlistUrl = oneShotRow[5].toString();
                AdManager().navigateWithAd(
                    context,
                    YoutubePlayerScreen(
                      title: subSection,
                      playlistLink: playlistUrl,
                    ));
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(title, textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}
