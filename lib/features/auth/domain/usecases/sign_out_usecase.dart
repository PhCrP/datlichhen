import '../repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _authRepository;

  SignOutUsecase(this._authRepository);

  Future<void> call() {
    return _authRepository.signOut();
  }
}
