import 'package:notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String id,
    required String password,
  });
  Future<AuthUser> createUser({
    required String id,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
