import 'package:isar/isar.dart';

part 'recent_device.g.dart';

@Collection()
class RecentDevice {
  Id id = Isar.autoIncrement;

  String ip;
  int port;
  String name;
  DateTime lastConnectionDate = DateTime.now();

  RecentDevice({required this.ip, required this.port, required this.name});
}
