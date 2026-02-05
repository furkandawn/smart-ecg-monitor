import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ecg_event_model.dart';
import 'ecg_event_repository.dart';

final ecgEventProvider =
    NotifierProvider<EcgEventController, List<EcgEventModel>>(
  EcgEventController.new,
);

class EcgEventController extends Notifier<List<EcgEventModel>> {
  @override
  List<EcgEventModel> build() {
    // Keep in-memory state in sync with persistent storage
    ref.listen<AsyncValue<List<EcgEventModel>>>(
      _eventsStreamProvider,
      (_, next) {
        if (next.hasValue) {
          state = next.value!;
        }
      },
    );

    return const [];
  }
}

/* ───────────── Database stream ───────────── */

final _eventsStreamProvider =
    StreamProvider<List<EcgEventModel>>((ref) {
  return ref.read(ecgEventRepositoryProvider).watchEvents();
});
