// Repository Provider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controller/auth_controller.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  return AuthRepositoryImpl(FirebaseAuthDataSource(_firebaseAuth));
});

final signInProvider = Provider<SignInUsecase>((ref) {
  return SignInUsecase(ref.read(authRepositoryProvider));
});
final signUpProvider = Provider<SignUpUsecase>((ref) {
  return SignUpUsecase(ref.read(authRepositoryProvider));
});
final signOutProvider = Provider<SignOutUsecase>((ref) {
  return SignOutUsecase(ref.read(authRepositoryProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final signIn = ref.read(signInProvider);
      final signUp = ref.read(signUpProvider);
      final signOut = ref.read(signOutProvider);
      return AuthController(signIn, signUp, signOut);
    });
