import 'package:flify/types/current_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentInfoProvider = StateProvider<CurrentInfo>(
  // We return the default sort type, here name.
  (ref) => CurrentInfo(),
);
