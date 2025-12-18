import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String label;
  final String? value;
  final double spacing;

  const DetailText({
    super.key,
    required this.label,
    this.value,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(value ?? ""),
        ],
      ),
    );
  }
}
