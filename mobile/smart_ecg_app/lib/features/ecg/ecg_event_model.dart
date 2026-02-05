enum EcgEventType {
  normal,
  emergency,
  signalLoss,
}

class EcgEventModel {
  final int? id;
  final DateTime timestamp;
  final EcgEventType type;
  final int? bpm;
  final List<double>? snapshot;

  const EcgEventModel({
    this.id,
    required this.timestamp,
    required this.type,
    this.bpm,
    this.snapshot,
  });
}