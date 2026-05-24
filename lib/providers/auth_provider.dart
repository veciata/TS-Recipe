import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import 'settings_provider.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

final class AuthGuest extends AuthState {
  const AuthGuest();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final SettingsService _settings;

  AuthNotifier(this._authService, this._settings)
      : super(const AuthUnauthenticated()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final user = await _authService.fetchCurrentUser();
      if (user != null) {
        await _settings.setGuestMode(false);
        state = AuthAuthenticated(user);
        return;
      }
      if (_settings.guestMode) {
        state = const AuthGuest();
        return;
      }
      state = const AuthUnauthenticated();
    } catch (e) {
      if (_settings.guestMode) {
        state = const AuthGuest();
      } else {
        state = AuthError(e.toString());
      }
    }
  }

  Future<void> continueAsGuest() async {
    await _settings.setGuestMode(true);
    state = const AuthGuest();
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _authService.login(email, password);
      if (user == null) {
        throw Exception('Could not load user profile after login');
      }
      await _settings.setGuestMode(false);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _authService.register({
        'username': username,
        'email': email,
        'password': password,
      });
      if (user == null) {
        throw Exception('Could not load user profile after registration');
      }
      await _settings.setGuestMode(false);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _authService.logout();
    } catch (_) {
      // Clear local session even if server logout fails
    } finally {
      await _settings.setGuestMode(false);
      state = const AuthUnauthenticated();
    }
  }

  Future<void> refreshToken() async {
    try {
      await _authService.refreshToken();
      final user = await _authService.fetchCurrentUser();
      if (user != null) {
        await _settings.setGuestMode(false);
        state = AuthAuthenticated(user);
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authServiceProvider),
    ref.watch(settingsServiceProvider),
  );
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return switch (authState) {
    AuthAuthenticated(:final user) => user,
    _ => null,
  };
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider) is AuthAuthenticated;
});

final isGuestProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider) is AuthGuest;
});

final canUseAppProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthAuthenticated || authState is AuthGuest;
});
