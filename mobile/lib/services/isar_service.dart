import 'package:flify/types/recent_device.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static late Isar db;

  static Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    IsarService.db = await Isar.open([RecentDeviceSchema], directory: dir.path);

    print("DB init");
    return IsarService.db;
  }
}
