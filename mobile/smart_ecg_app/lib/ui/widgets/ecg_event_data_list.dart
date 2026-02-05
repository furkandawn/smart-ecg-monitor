import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';

class EcgEventDataList extends ConsumerWidget {
  final List<double> samples;

  const EcgEventDataList({
    super.key,
    required this.samples,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    if (samples.isEmpty) {
      return Center(child: Text(i18n.tr('no_data')));
    }

    return ListView.separated(
      itemCount: samples.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final val = samples[index];
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Text(
            '#$index',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          title: Text(
            val.toStringAsFixed(4), // High precision format
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}