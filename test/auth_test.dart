import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('should not be init to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('cant log out if not init', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitialized>()),
      );
    });

    test('should init', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('user should be null after init', () {
      expect(provider.currentUser, null);
    });

    test(
      'should init in less than 2 sec',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('createUser should delegate to logIn func', () async {
      final notFoundUser = provider.createUser(
        id: 'foo@bar.com',
        password: 'asdf',
      );
      expect(
        notFoundUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );
      final wrongPassUser = provider.createUser(
        id: 'asdf@bar.com',
        password: 'foobar',
      );
      expect(
        wrongPassUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );
      final weakPassUser = provider.createUser(
        id: 'asdf@bar.com',
        password: 'f',
      );
      expect(
        weakPassUser,
        throwsA(const TypeMatcher<WeakPasswordAuthException>()),
      );

      final user = await provider.createUser(
        id: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to log out and log in', () async {
      await provider.logOut();
      await provider.logIn(id: 'id', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitialized implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String id,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitialized();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(id: id, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String id,
    required String password,
  }) {
    if (!isInitialized) throw NotInitialized();
    if (id == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    if (password == 'f') throw WeakPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitialized();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitialized();
    if (_user == null) throw UserNotFoundAuthException();
    _user = const AuthUser(isEmailVerified: true);
  }
}
