import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final UserCredential user;
  final String message;
  AuthResult(this.user, this.message);
}
