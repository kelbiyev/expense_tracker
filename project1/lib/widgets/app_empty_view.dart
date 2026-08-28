import 'package:flutter/material.dart';

import '../core/constants/ui_colors.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message, style: const TextStyle(color: UiColors.grey)),
      ),
    );
  }
}