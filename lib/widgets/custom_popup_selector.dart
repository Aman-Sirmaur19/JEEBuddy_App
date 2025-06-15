import 'package:flutter/material.dart';

class CustomPopupSelector extends StatelessWidget {
  final String title; // e.g. "Choose Gender"
  final String selectedValue; // e.g. "Choose Gender" or "Female-only"
  final List<String>
      options; // e.g. ['Choose Gender', 'Female-only', 'Gender-Neutral']
  final void Function(String) onSelected;

  const CustomPopupSelector({
    Key? key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != 'Choose Sort By') ...[
          Text(
            title.replaceFirst('Choose ', 'Select your '),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
        ],
        PopupMenuButton<String>(
          onSelected: onSelected,
          constraints: const BoxConstraints(minWidth: double.infinity),
          itemBuilder: (context) => options.map((option) {
            final isSelected = (option == selectedValue);
            return PopupMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(color: isSelected ? Colors.orange : null),
              ),
            );
          }).toList(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tooltip: title,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedValue,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: (selectedValue.startsWith('Choose'))
                          ? Colors.grey
                          : null,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
