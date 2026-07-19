import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(const ConnectivityInitial());

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  int _checkToken = 0;

  Future<void> start() async {
    if (_subscription != null) {
      await checkConnection(force: true);
      return;
    }

    await checkConnection(force: true);
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // Show offline immediately when the interface drops.
      if (!_hasNetworkInterface(results)) {
        if (!isClosed) emit(const ConnectivityOffline());
        return;
      }
      checkConnection(force: true);
    });
  }

  /// Rechecks network status.
  /// Use [force] when the user taps retry or the app returns to foreground.
  Future<void> checkConnection({bool force = false}) async {
    if (isClosed) return;

    final token = ++_checkToken;

    try {
      final results = await _connectivity.checkConnectivity();
      if (isClosed || token != _checkToken) return;

      if (!_hasNetworkInterface(results)) {
        emit(const ConnectivityOffline());
        return;
      }

      final hasInternet = await _hasInternetAccess();
      if (isClosed || token != _checkToken) return;

      emit(
        hasInternet ? const ConnectivityOnline() : const ConnectivityOffline(),
      );
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
      if (!isClosed && token == _checkToken) {
        emit(const ConnectivityOffline());
      }
    }
  }

  bool _hasNetworkInterface(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn ||
          result == ConnectivityResult.other,
    );
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(milliseconds: 700));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
