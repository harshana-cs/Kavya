// lib/state/auth_provider.dart
//
// Same reasoning as poems_provider.dart: whether the person is logged in
// needs to be known by main.dart (to decide Login screen vs the app
// itself) AND by screens deep in the app (e.g. a profile screen showing
// "log out"). So it lives in a shared Riverpod provider rather than any
// one screen's local state.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

enum AuthStatus { checking, loggedOut, loggedIn }

class AuthState {
  final AuthStatus status;
  final String? username;
  const AuthState({required this.status, this.username});

  const AuthState.checking() : this(status: AuthStatus.checking);
  const AuthState.loggedOut() : this(status: AuthStatus.loggedOut);
  const AuthState.loggedIn(String username)
      : this(status: AuthStatus.loggedIn, username: username);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.checking()) {
    _restoreSession();
  }

  /// Runs once when the app starts: if a token is already saved on the
  /// device (from a previous login), skip straight past the login
  /// screen instead of making the person log in every time they open
  /// the app.
  Future<void> _restoreSession() async {
    final token = await ApiService.accessToken;
    final username = await ApiService.currentUsername;
    if (token != null && username != null) {
      state = AuthState.loggedIn(username);
    } else {
      state = const AuthState.loggedOut();
    }
  }

  Future<void> login(String username, String password) async {
    await ApiService.login(username: username, password: password);
    state = AuthState.loggedIn(username);
  }

  Future<void> register(String username, String email, String password) async {
    await ApiService.register(username: username, email: email, password: password);
    // Registering doesn't log you in by itself on the backend — do that
    // as a second step so the person lands straight in the app.
    await ApiService.login(username: username, password: password);
    state = AuthState.loggedIn(username);
  }

  Future<void> logout() async {
    await ApiService.logout();
    state = const AuthState.loggedOut();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
