part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.displayName = const DisplayName.pure(),
    this.password = const Password.pure(),
  });

  final FormzStatus status;
  final Email email;
  final DisplayName displayName;
  final Password password;

  SignUpState copyWith({
    FormzStatus status,
    Email email,
    DisplayName displayName,
    Password password,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, email, displayName, password,];
}

