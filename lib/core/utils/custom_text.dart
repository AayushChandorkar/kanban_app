import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String label;
  final String? value;
  final double? textSize;

  const DetailText({
    super.key,
    required this.label,
    this.value,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          overflow: TextOverflow.visible,
          style: TextStyle(fontSize: textSize ?? 16)
        ),
        Text(value ?? ""),
      ],
    );
  }
}
