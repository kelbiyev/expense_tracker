import 'package:flutter/material.dart';

import '../core/constants/ui_strings.dart';


class AppErrorView extends StatelessWidget { 
  const AppErrorView({
    super.key,
    required this.message,
    required this.onRetry
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text(UiStrings.retry))
          ],
        )
      ),
    );
  }

}