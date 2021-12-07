import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  User user;
  String message;
  AuthResult({required this.user, required this.message});
}
