import 'dart:typed_data';

/// Decodes raw ECG snapshot bytes into normalized samples.
/// Protocol:
/// - Int16 little-endian samples
/// - Scaled by ADC factor (2048.0)
List<double> decodeEcgSnapshot(Uint8List bytes) {
  final bd = ByteData.sublistView(bytes);

  final sampleCount = bytes.length ~/ 2;
  return List<double>.generate(
    sampleCount,
    (i) => bd.getInt16(i * 2, Endian.little) / 2048.0,
  );
}
