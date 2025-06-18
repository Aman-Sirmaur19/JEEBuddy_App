import 'package:flutter/material.dart';

import '../services/ad_manager.dart';
import '../providers/sheet_data_provider.dart';
import '../screens/notes/pdfs_screen.dart';
import '../screens/lectures/playlists_screen.dart';
import '../screens/lectures/youtube_player_screen.dart';

class CustomGridView extends StatelessWidget {
  final String label;
  final List<String> items;
  final SheetDataProvider provider;

  const CustomGridView({
    super.key,
    required this.label,
    required this.items,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
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
            if (label == 'Lectures') {
              AdManager()
                  .navigateWithAd(context, PlaylistsScreen(title: subSection));
            } else if (label == 'One Shots') {
              final oneShotRow = provider.data.skip(1).firstWhere(
                    (row) => (row.length > 6 &&
                        (row[3]?.toString().trim() == 'One Shots') &&
                        (row[4]?.toString().trim() == subSection)),
                    orElse: () => [],
                  );
              final playlistUrl =
                  oneShotRow.length > 6 ? oneShotRow[6].toString() : '';
              AdManager().navigateWithAd(
                  context,
                  YoutubePlayerScreen(
                    title: subSection,
                    playlistLink: playlistUrl,
                  ));
            } else {
              AdManager().navigateWithAd(context, PdfsScreen(title: title));
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
