import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketProvider = StateProvider<IO.Socket?>((ref) => null);
