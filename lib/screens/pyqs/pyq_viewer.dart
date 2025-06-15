import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/internet_connectivity_button.dart';

class PYQViewer extends StatefulWidget {
  final String pdfName;
  final String pdfUrl;

  const PYQViewer({super.key, required this.pdfName, required this.pdfUrl});

  @override
  State<PYQViewer> createState() => _PYQViewerState();
}

class _PYQViewerState extends State<PYQViewer> {
  Future<String>? _pdfPathFuture;
  PDFViewController? _pdfViewController;
  int? _totalPages;

  void _goToPageDialog() {
    final TextEditingController pageController = TextEditingController();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Go to page',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: pageController,
                isNum: true,
                hintText: 'Enter page no. (1 - $_totalPages)',
                onFieldSubmitted: (_) {
                  final page = int.tryParse(pageController.text);
                  if (page != null &&
                      page > 0 &&
                      (_totalPages == null || page <= _totalPages!)) {
                    _pdfViewController?.setPage(page - 1);
                  }
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final page = int.tryParse(pageController.text);
                  if (page != null &&
                      page > 0 &&
                      (_totalPages == null || page <= _totalPages!)) {
                    _pdfViewController?.setPage(page - 1);
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Go'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pdfPathFuture = _initialisePdf();
  }

  Future<String> _initialisePdf() async {
    try {
      return 'https://drive.google.com/uc?export=download&id=${widget.pdfUrl.trim()}';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _goToPageDialog,
          tooltip: 'Go to Page',
          backgroundColor: Colors.orange,
          child:
              const Icon(CupertinoIcons.doc_text_search, color: Colors.black),
        ),
        body: FutureBuilder<String>(
          future: _pdfPathFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Invalid PDF path.'));
            }
            final path = snapshot.data!;
            return PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    onViewCreated: (controller) {
                      _pdfViewController = controller;
                    },
                    onPageChanged: (currentPage, totalPages) {
                      setState(() {
                        _totalPages = totalPages;
                      });
                    },
                  ).cachedFromUrl(
                    path,
                    placeholder: (progress) => Center(
                        child: Text(
                      '$progress %\nLoading',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                    errorWidget: (error) => InternetConnectivityButton(
                      onPressed: () => setState(() {
                        _pdfPathFuture = _initialisePdf();
                      }),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
