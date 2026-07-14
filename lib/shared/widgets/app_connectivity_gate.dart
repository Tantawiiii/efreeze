import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/connectivity/connectivity_cubit.dart';
import '../../features/connectivity/ui/no_internet_screen.dart';

/// Wraps the whole app and shows [NoInternetScreen] automatically when offline.
/// Rechecks connectivity whenever the app returns to foreground.
class AppConnectivityGate extends StatefulWidget {
  const AppConnectivityGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppConnectivityGate> createState() => _AppConnectivityGateState();
}

class _AppConnectivityGateState extends State<AppConnectivityGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ConnectivityCubit>().checkConnection(force: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ConnectivityCubit>().checkConnection(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        final isOffline = state is ConnectivityOffline;

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            if (isOffline)
              const Positioned.fill(
                child: Material(
                  color: Colors.white,
                  child: NoInternetScreen(),
                ),
              ),
          ],
        );
      },
    );
  }
}
