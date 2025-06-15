import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sheet_data_provider.dart';
import '../../widgets/search_text_field.dart';
import 'pdf_viewer_screen.dart';

class PdfsScreen extends StatefulWidget {
  final String title;

  const PdfsScreen({super.key, required this.title});

  @override
  State<PdfsScreen> createState() => _PdfsScreenState();
}

class _PdfsScreenState extends State<PdfsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SheetDataProvider>(context);

    Widget bodyContent;

    if (provider.isLoading) {
      bodyContent =
          const Center(child: CircularProgressIndicator(color: Colors.orange));
    } else if (provider.error != null) {
      bodyContent =
          Center(child: Text('Failed to load PDFs: ${provider.error}'));
    } else {
      final rows = provider.data.skip(1);
      final filteredPdfs = rows.where((row) {
        if (row.length < 7) return false;
        final bottomTab = row[1]?.toString().trim() ?? '';
        final tab = row[2]?.toString().trim() ?? '';
        final subSection = row[4]?.toString().trim() ?? '';
        return bottomTab == 'Notes' &&
            (tab == 'Notes' || tab == 'Sheets' || tab == 'Books') &&
            subSection == widget.title;
      }).toList();

      final searchFiltered = _searchQuery.isEmpty
          ? filteredPdfs
          : filteredPdfs.where((row) {
              final name =
                  row.length > 5 ? row[5].toString().toLowerCase() : '';
              return name.contains(_searchQuery.toLowerCase());
            }).toList();

      if (filteredPdfs.isEmpty) {
        bodyContent = const Center(child: Text('No PDFs found'));
      } else {
        bodyContent = Column(
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: searchFiltered.length,
                itemBuilder: (context, index) {
                  final row = searchFiltered[index];
                  final pdfName =
                      row.length > 5 ? row[5].toString() : 'PDF $index';
                  final pdfUrl = row.length > 6 ? row[6].toString() : '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => PdfViewerScreen(
                            pdfName: pdfName,
                            pdfUrl: pdfUrl,
                          ),
                        ),
                      ),
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text(pdfName),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
        body: bodyContent,
      ),
    );
  }
}
