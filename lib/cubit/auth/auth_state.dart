part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthSignIn extends AuthState {
  const AuthSignIn();
}

class AuthSignInError extends AuthState {
  final String message;

  const AuthSignInError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthRegistration extends AuthState {
  const AuthRegistration();
}

class AuthRegistrationError extends AuthState {
  final String message;

  const AuthRegistrationError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLogOutState extends AuthState {
  const AuthLogOutState();
}

extension AuthStateExtention on AuthState {
  List<Object> get getProps {
    final state = this;
    if(state is AuthRegistrationError) return state.props;
    if(state is AuthSignInError) return state.props;
    return [];
  }
}