import '../repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository _authRepository;

  SignUpUsecase(this._authRepository);

  Future<void> call(String email, String password) {
    return _authRepository.signUp(email, password);
  }
}
