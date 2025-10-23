import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<UserEntity?> get user => _dataSource.user;

  @override
  Future<void> signIn(String email, String password) =>
      _dataSource.signIn(email, password);

  @override
  Future<void> signUp(String email, String password) =>
      _dataSource.signUp(email, password);

  @override
  Future<void> signOut() => _dataSource.signOut();
}
