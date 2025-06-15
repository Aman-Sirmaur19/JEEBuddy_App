import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final String searchQuery;
  final void Function(String) onChanged;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Search Chapters...',
          prefixIcon: const Icon(CupertinoIcons.search),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(CupertinoIcons.clear),
                  tooltip: 'Clear',
                  onPressed: () {
                    widget.onChanged('');
                    widget.controller.clear();
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
