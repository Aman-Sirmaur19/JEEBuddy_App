import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/lectures/playlists_screen.dart';
import '../screens/notes/pdfs_screen.dart';

class CustomGridView extends StatelessWidget {
  final String label;
  final List<String> items;

  const CustomGridView({super.key, required this.label, required this.items});

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
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => label == 'Lectures'
                  ? PlaylistsScreen(title: title)
                  : PdfsScreen(title: title),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
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
