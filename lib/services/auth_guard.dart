import 'dart:async';

import 'package:flutter/material.dart';

typedef AuthGuardUnauthenticatedHandler = void Function(
    BuildContext buildContext);

class AuthGuard extends StatefulWidget {
  final Widget child;
  final Widget loadingScreen;
  final AuthGuardUnauthenticatedHandler unauthenticatedHandler;
  final Stream<AuthGuardStatus> authenticationStream;
  AuthGuard({
    super.key,
    required this.child,
    required this.loadingScreen,
    required this.unauthenticatedHandler,
    required this.authenticationStream,
  }) {
    assert(child != null);
    assert(loadingScreen != null);
    assert(unauthenticatedHandler != null);
    assert(authenticationStream != null);
  }

  @override
  _AuthGuardState createState() {
    return _AuthGuardState();
  }
}

enum AuthGuardStatus {
  authenticated,
  notAuthenticated,
}

class _AuthGuardState extends State<AuthGuard> {
  late StreamSubscription<AuthGuardStatus> _subscription;
  late Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthGuardStatus>(
      stream: widget.authenticationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          currentWidget = widget.loadingScreen;
          return currentWidget;
        } else if (snapshot.data == AuthGuardStatus.authenticated) {
          currentWidget = widget.child;
        }
        return currentWidget;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    print('Dispose');
    _subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    currentWidget = widget.loadingScreen;
    _subscription = widget.authenticationStream.listen(_onAuthenticationChange);
  }

  _onAuthenticationChange(AuthGuardStatus status) {
    if (status == AuthGuardStatus.notAuthenticated) {
      widget.unauthenticatedHandler(context);
    }
  }
}
