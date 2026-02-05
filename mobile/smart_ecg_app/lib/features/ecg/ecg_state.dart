class EcgState {
  final List<double> samples; // normalized [-1..1], fixed length snapshot
  final bool liveEnabled;

  const EcgState({
    required this.samples,
    required this.liveEnabled,
  });

  EcgState copyWith({
    List<double>? samples,
    bool? liveEnabled,
  }) {
    return EcgState(
      samples: samples ?? this.samples,
      liveEnabled: liveEnabled ?? this.liveEnabled,
    );
  }
}
