import 'dart:typed_data';

class BleEmergencyPacket {
  final int? bpm;
  final Uint8List snapshot; // raw int16 LE samples

  BleEmergencyPacket({
    this.bpm,
    required this.snapshot,
  });
}