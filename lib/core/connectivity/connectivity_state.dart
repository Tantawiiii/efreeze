part of 'connectivity_cubit.dart';

abstract class ConnectivityState {
  const ConnectivityState();
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial();
}

class ConnectivityOnline extends ConnectivityState {
  const ConnectivityOnline();
}

class ConnectivityOffline extends ConnectivityState {
  const ConnectivityOffline();
}
