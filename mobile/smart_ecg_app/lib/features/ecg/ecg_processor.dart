import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ecg_state.dart';

final ecgProcessorProvider =
    NotifierProvider<EcgProcessor, EcgState>(EcgProcessor.new);

class EcgProcessor extends Notifier<EcgState> {
  // 125Hz * 4 seconds = 500 points on screen
  static const int _bufferLen = 500;
  
  // Internal Circular Buffer
  final List<double> _buffer = List.filled(_bufferLen, 0.0);
  int _head = 0;

  @override
  EcgState build() {
    return EcgState(
      samples: List.filled(_bufferLen, 0.0),
      liveEnabled: false,
    );
  }

  void setLiveEnabled(bool enabled) {
    state = state.copyWith(liveEnabled: enabled);
    if (enabled) {
      _buffer.fillRange(0, _bufferLen, 0.0);
      _head = 0;
    }
  }

  void addDataPoint(int rawSample) {
    if (!state.liveEnabled) return;

    // Normalize: ESP32 ADC (0..4095) -> UI (-1.0..1.0)
    // Center is ~2048
    double val = (rawSample - 2048) / 2048.0;

    _buffer[_head] = val;
    _head = (_head + 1) % _bufferLen;

    if (_head % 5 == 0) {
      _publish();
    }
  }

  void _publish() {
    // Unroll ring buffer for the UI
    // This creates the "scrolling" effect
    final out = List<double>.filled(_bufferLen, 0.0);
    int idx = _head;
    
    for (int i = 0; i < _bufferLen; i++) {
      out[i] = _buffer[idx];
      idx = (idx + 1) % _bufferLen;
    }

    state = state.copyWith(samples: out);
  }
}