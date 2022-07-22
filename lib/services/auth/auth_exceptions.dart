// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUsedAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class GenericFirebaseAuthException implements Exception {}

// If user in null after register
class UserNotLoggedInAuthException implements Exception {}
