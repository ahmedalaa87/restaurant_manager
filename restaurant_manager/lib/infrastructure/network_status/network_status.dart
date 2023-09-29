import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class INetworkStatus {
  Future<bool> isConnected();
}


class NetworkStatus extends INetworkStatus {
  final InternetConnectionChecker internetConnectionChecker;

  NetworkStatus({required this.internetConnectionChecker});

  @override
  Future<bool> isConnected() async {
    return true;
  }
}