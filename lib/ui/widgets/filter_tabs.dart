import 'package:flutter/material.dart';

/// Filter tabs for All, Active, and Done notes.
class FilterTabs extends StatelessWidget {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('All'),
        Text('Active'),
        Text('Done'),
      ],
    );
  }
}
