import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';
import '../../features/ecg/ecg_event_model.dart';
import '../../features/ecg/ecg_event_repository.dart';
import 'history_detail_screen.dart'; 

import '../actions/history_item_handler.dart';
import '../widgets/confirm_dialog.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);
    final repo = ref.watch(ecgEventRepositoryProvider);
    final stream = repo.watchEvents();

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.tr('ecg_history')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: i18n.tr('clear_all_tooltip'),
            onPressed: () => _confirmClearAll(context, ref, i18n),
          ),
        ],
      ),
      body: StreamBuilder<List<EcgEventModel>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${i18n.tr('error_label')}${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!;

          if (events.isEmpty) {
            return Center(
              child: Text(
                i18n.tr('no_abnormalities'),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            key: const PageStorageKey('history'),
            itemCount: events.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final event = events[index];
              
              return HistoryItemHandler(
                event: event,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EcgEventDetailScreen(event: event),
                    ),
                  );
                },
                onDelete: () {
                  if (event.id != null) {
                    repo.deleteEvent(event.id!);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref, I18n i18n) async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: i18n.tr('clear_all_history_title'),
      content: i18n.tr('clear_all_history_confirm'),
      cancelText: i18n.tr('cancel'),
      confirmText: i18n.tr('delete_all'),
      isDestructive: true,
    );
    if (confirmed) {
      ref.read(ecgEventRepositoryProvider).clearAllEvents();
    }
  }
}