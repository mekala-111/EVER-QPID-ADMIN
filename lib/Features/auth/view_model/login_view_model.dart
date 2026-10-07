import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:everqpidadmin/Features/auth/repository/auth_repository.dart';
import 'package:everqpidadmin/Features/auth/view/otpscreen.dart';
import 'package:everqpidadmin/Features/auth/view/passwordscreen.dart';
import 'package:flutter/material.dart';

import '../../../Data/Network/network_api_service_v2.dart';
import '../../../Settings/common/widgets/error_msg.dart';
import '../../../Settings/utils/p_pages.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? loginErrorText;

  final authRepository = AuthRepository(NetworkApiServiceV2());

  // ---------------- LOGIN ----------------
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      loginErrorText = null;

      final response = await authRepository.login(
        email: email,
        passwords: password,
      );

      if (response['status'] == true) {
        if (!context.mounted) return;

        if (LoggedInUser.isAdmin) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PPages.mainScreen,
            (_) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PPages.mainScreen2,
            (_) => false,
          );
        }
      }
    } catch (e) {
      loginErrorText = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- FORGOT PASSWORD ----------------
  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      _setLoading(true);

      final success = await authRepository.forgotPass(email);

      if (!context.mounted) return;

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otpscreen(email: email),
          ),
        );
      }
    } catch (e) {
      ErrorMsg.showSnakError(context, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      _setLoading(true);

      final success = await authRepository.verifyOtp(email, otp, "");

      if (!context.mounted) return;

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Passwordscreen(email: email),
          ),
        );
      }
    } catch (e) {
      ErrorMsg.showSnakError(context, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- RESET PASSWORD ----------------
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _setLoading(true);

      await authRepository.reset(email, confirmPassword, newPassword);
      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        PPages.login,
        (_) => false,
      );
    } catch (e) {
      if (context.mounted) {
        ErrorMsg.showSnakError(context, e.toString());
      }
    } finally {
      _setLoading(false);
    }
  }
}
