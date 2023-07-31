import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:volume_controller/volume_controller.dart';

final selfVolumeProvider = Provider.autoDispose<Stream<int>>((ref) {
  final volumes = BehaviorSubject<int>();

  VolumeController().listener((p0) {
    volumes.sink.add((p0 * 100).floor());
  });

  ref.onDispose(() {
    VolumeController().removeListener();
  });
  ref.keepAlive();

  return volumes.stream;
});
