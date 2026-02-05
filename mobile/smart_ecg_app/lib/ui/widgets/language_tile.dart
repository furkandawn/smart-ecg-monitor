import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 28),
      ),
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: onTap,
    );
  }
}