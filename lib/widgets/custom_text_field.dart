import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.isNum = false,
    this.prefixIcon,
    required this.hintText,
    this.suffix,
    required this.onFieldSubmitted,
  });

  final TextEditingController? controller;
  final bool isNum;
  final IconData? prefixIcon;
  final String hintText;
  final Widget? suffix;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hintText == 'Message' ? null : 45,
      child: TextFormField(
        controller: controller,
        keyboardType: isNum ? TextInputType.number : TextInputType.emailAddress,
        maxLines: hintText == 'Message' ? 5 : 1,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: Colors.orange,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          contentPadding: prefixIcon == null
              ? const EdgeInsets.symmetric(vertical: 10, horizontal: 12)
              : const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    prefixIcon!,
                    size: 20,
                    color: Colors.grey,
                  ),
                )
              : null,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 40, maxHeight: 30),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: suffix,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }
}
