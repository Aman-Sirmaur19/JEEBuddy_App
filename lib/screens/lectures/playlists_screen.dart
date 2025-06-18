import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ad_manager.dart';
import '../../widgets/custom_banner_ad.dart';
import '../../widgets/search_text_field.dart';
import '../../providers/sheet_data_provider.dart';
import 'youtube_player_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  final String title;

  const PlaylistsScreen({super.key, required this.title});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    Widget bodyContent;

    if (provider.isLoading) {
      bodyContent =
          const Center(child: CircularProgressIndicator(color: Colors.orange));
    } else if (provider.error != null) {
      bodyContent =
          Center(child: Text('Failed to load Playlists: ${provider.error}'));
    } else {
      final rows = provider.data.skip(1);
      final filteredPlaylists = rows.where((row) {
        if (row.length < 7) return false;
        final bottomTab = row[1]?.toString().trim() ?? '';
        final tab = row[2]?.toString().trim() ?? '';
        final subSection = row[4]?.toString().trim() ?? '';
        final name = row[5]?.toString().toLowerCase() ?? '';

        return bottomTab == 'Lectures' &&
            (tab == 'Physics' || tab == 'Chemistry' || tab == 'Maths') &&
            subSection == widget.title &&
            name.contains(_searchQuery.toLowerCase());
      }).toList();

      if (filteredPlaylists.isEmpty) {
        bodyContent = const Center(child: Text('No playlists found'));
      } else {
        bodyContent = ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: filteredPlaylists.length,
          itemBuilder: (context, index) {
            final row = filteredPlaylists.elementAt(index);
            final playlistName =
                row.length > 5 ? row[5].toString() : 'Playlist $index';
            final playlistUrl = row.length > 6 ? row[6].toString() : '';

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                onTap: () => AdManager().navigateWithAd(
                    context,
                    YoutubePlayerScreen(
                      title: playlistName,
                      playlistLink: playlistUrl,
                    )),
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Text(playlistName),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
          title: Text(widget.title),
        ),
        bottomNavigationBar: const CustomBannerAd(),
        body: Column(
          children: [
            SearchTextField(
              controller: _searchController,
              searchQuery: _searchQuery,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            Expanded(child: bodyContent),
          ],
        ),
      ),
    );
  }
}
