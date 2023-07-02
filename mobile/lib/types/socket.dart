class Metadata {
  String? selfIp;
  String? deviceName;
  String? os;

  Metadata({this.selfIp, this.deviceName, this.os});

  Map toJson() => {'selfIp': selfIp, 'deviceName': deviceName, 'os': os};
}
