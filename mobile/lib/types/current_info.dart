class CurrentInfo {
  String? hostname;
  String? audioDeviceName;
  VolumeState? volume;

  CurrentInfo({this.hostname, this.audioDeviceName, this.volume});

  CurrentInfo copyWith(
      {String? hostname, String? audioDeviceName, VolumeState? volume}) {
    return CurrentInfo(
        audioDeviceName: audioDeviceName ?? this.audioDeviceName,
        hostname: hostname ?? this.hostname,
        volume: volume ?? this.volume);
  }
}

class VolumeState {
  int volume;
  bool isMuted;

  VolumeState(this.volume, this.isMuted);

  VolumeState.fromPayload(dynamic payload)
      : volume = int.tryParse(payload?['volume']?.toString() ?? "") ?? 0,
        isMuted = payload?['isMuted']?.toString() == "true";

  Map<String, dynamic> toJson() {
    return {
      'volume': volume,
      'isMuted': isMuted,
    };
  }
}
