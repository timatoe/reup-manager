import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:reup_manager/data/authentication_repository.dart';
import 'package:reup_manager/screens/widgets/formz_inputs/display_name.dart';
import 'package:reup_manager/screens/widgets/formz_inputs/password.dart';
import 'package:reup_manager/screens/widgets/formz_inputs/email.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is SignUpDisplayNameChanged) {
      yield _mapDisplayNameChangedToState(event, state);
    } else if (event is SignUpPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is SignUpSubmitted) {
      yield* _mapSignUpSubmittedToState(event, state);
    }
  }

  SignUpState _mapEmailChangedToState(
    SignUpEmailChanged event,
    SignUpState state,
  ) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.displayName, state.password, email]),
    );
  }

  SignUpState _mapDisplayNameChangedToState(
    SignUpDisplayNameChanged event,
    SignUpState state,
  ) {
    final displayName = DisplayName.dirty(event.displayName);
    return state.copyWith(
      displayName: displayName,
      status: Formz.validate([state.email, state.password, displayName]),
    );
  }

  SignUpState _mapPasswordChangedToState(
    SignUpPasswordChanged event,
    SignUpState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.email, state.displayName]),
    );
  }

  Stream<SignUpState> _mapSignUpSubmittedToState(
    SignUpSubmitted event,
    SignUpState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.signUp(
            email: state.email.value,
            displayName: state.displayName.value,
            password: state.password.value);
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (exception) {
        print(exception);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
