import 'dart:typed_data';

class Metadata {
  String? selfIp;
  String? deviceName;
  String? os;

  Metadata({this.selfIp, this.deviceName, this.os});

  Map toJson() => {'selfIp': selfIp, 'deviceName': deviceName, 'os': os};
}

class Session {
  String? id;
  AudioParams? params;
}

class AudioParams {
  int? channelCount;
  int? sampleRate;
}

class AudioPayload {
  Uint8List? d;
  String? i;
  DateTime? t;
}

class DataHeartbeat {
  DateTime? initialDataTimestamp;
  DateTime timestamp;

  DataHeartbeat({this.initialDataTimestamp, required this.timestamp});

  Map toJson() => {
        'initialDataTimestamp': initialDataTimestamp?.millisecondsSinceEpoch,
        'timestamp': timestamp.millisecondsSinceEpoch
      };
}
