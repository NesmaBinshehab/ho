import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:honnyapp/core/constants/app_strings.dart';
// import 'package:honnyapp/core/constants/app_colors.dart';
import 'package:honnyapp/core/services/auth_service.dart';


class AuthController {

  final AuthService _authService = AuthService();

  // LOGIN
  Future<String?> login({

    required String email,
    required String password,

  }) async {

    return await _authService.login(
      email: email,
      password: password,
    );
  }

  // SIGN UP
  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,

  }) async {

    return await _authService.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}