import '../repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository _authRepository;

  SignInUsecase(this._authRepository);

  Future<void> call(String email, String password) {
    return _authRepository.signIn(email, password);
  }
}
