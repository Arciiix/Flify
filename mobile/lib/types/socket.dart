class Metadata {
  String? selfIp;
  String? deviceName;

  Metadata({this.selfIp, this.deviceName});

  Map toJson() => {'selfIp': selfIp, 'deviceName': deviceName};
}
