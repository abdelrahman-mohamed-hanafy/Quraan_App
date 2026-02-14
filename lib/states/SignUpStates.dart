sealed class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String? message; SignUpSuccess({this.message});
}

class SignUpError extends SignUpState {
  final String message; SignUpError(this.message);
}

class SignUpValidationError extends SignUpState {
  final String message; SignUpValidationError(this.message);
}