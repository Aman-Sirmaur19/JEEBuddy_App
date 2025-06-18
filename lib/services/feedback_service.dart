import 'package:flutter/material.dart';

class FeedbackService {
  static Widget builder(
    BuildContext context,
    Future<void> Function(String, {Map<String, dynamic>? extras}) onSubmit,
    ScrollController? scrollController,
  ) {
    final TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Send Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Please describe your issue or suggestion:'),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit Feedback'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final userMessage = controller.text.trim();
                  if (userMessage.isEmpty) return;

                  // Use onSubmit to trigger screenshot capture & access extras
                  await onSubmit(userMessage, extras: {
                    'sendEmail': true,
                  });
                  Navigator.of(context).pop(); // Close feedback UI
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
