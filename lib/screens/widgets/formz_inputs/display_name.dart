import 'package:formz/formz.dart';

enum DisplayNameValidationError { empty }

class DisplayName extends FormzInput<String, DisplayNameValidationError> {
  const DisplayName.pure() : super.pure('');
  const DisplayName.dirty([String value = '']) : super.dirty(value);

  @override
  DisplayNameValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : DisplayNameValidationError.empty;
  }
}
