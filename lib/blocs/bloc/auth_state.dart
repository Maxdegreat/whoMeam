part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenicated }

class AuthState extends Equatable {
  final auth.User? user;
  final AuthStatus status;
  final Userm? userm;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
    required this.userm,
  });

  factory AuthState.unknown() => const AuthState(userm: null);

  factory AuthState.authenicated({required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated, userm: null);
  }

  factory AuthState.unauthenicated() =>
      const AuthState(status: AuthStatus.unauthenicated, userm: null);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [user, status, userm];

  AuthState copyWith({
    auth.User? user,
    AuthStatus? status,
    Userm? userm,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      userm: userm ?? this.userm
    );
  }
}
