import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_app/models/user.dart';

import 'settings_provider.dart';

class AuthStateNotifier extends AsyncNotifier<User?> {

  @override
  FutureOr<User?> build() {
    final usr = ref.watch(currentUserProvider);
    return usr;
  }

  login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    ref.read(currentUserProvider.notifier).update(User(email: email, password: password));
  }

  logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    ref.read(currentUserProvider.notifier).update(null);
  }
  
}

final authStateNotifierProvider = AsyncNotifierProvider<AuthStateNotifier, User?>(AuthStateNotifier.new);
