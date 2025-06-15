import 'package:flutter/material.dart';

class InternetConnectivityButton extends StatefulWidget {
  final void Function() onPressed;

  const InternetConnectivityButton({super.key, required this.onPressed});

  @override
  State<InternetConnectivityButton> createState() =>
      _InternetConnectivityButtonState();
}

class _InternetConnectivityButtonState
    extends State<InternetConnectivityButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Kindly check your internet connection ᯤ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Retry'),
          ),
        ]),
      ),
    );
  }
}
