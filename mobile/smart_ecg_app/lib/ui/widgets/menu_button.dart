import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
}