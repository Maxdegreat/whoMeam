import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whomeam/models/user_model.dart';
import 'package:whomeam/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  late StreamSubscription<auth.User?> _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.unknown()) {
    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      await _authRepository.logout();
    }
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    if (event.user != null) {
      yield AuthState.authenicated(user: event.user!);
    } else {
      yield AuthState.unauthenicated();
    }
    // ----------- METHODS BELOW -----------------
  }
}