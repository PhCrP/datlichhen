import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../../../features/auth/domain/usecases/sign_up_usecase.dart';
// import '../../domain/entities/user_entity.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final SignInUsecase _signIn;
  final SignUpUsecase _signUp;
  final SignOutUsecase _signOut;

  AuthController(this._signIn, this._signUp, this._signOut)
    : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _signIn.call(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _signUp.call(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _signOut.call();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
