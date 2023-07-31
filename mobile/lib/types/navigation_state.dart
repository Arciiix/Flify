class HomeScreenNavigationState {
  String? ip;
  String? port;
  String? name;

  HomeScreenNavigationState({this.ip, this.port, this.name});

  HomeScreenNavigationState.fromQueryParams(Map<String, String> params)
      : ip = params['ip'],
        name = params['name'],
        port = params['port'];
}

class ConnectionScreenNavigationState extends HomeScreenNavigationState {
  int? currentReconnectIndex =
      0; // If not 0, it will connect to the current data after a delay. Number of reconnections that already happened to the given device. Starts from 1 (0 = don't reconnect)

  ConnectionScreenNavigationState(
      {required super.ip,
      required super.port,
      required super.name,
      this.currentReconnectIndex});
}
