import 'package:everqpidadmin/Data/Network/network_api_service_v2.dart';
import 'package:everqpidadmin/Features/helpsupport/repo/repo.dart';
import 'package:flutter/material.dart';

class HelpViewModel extends ChangeNotifier {
  final _repo = HelpRepo(NetworkApiServiceV2());

  // ================= STATE =================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _email;
  String? get email => _email;

  String? _error;
  String? get error => _error;

  String? _successMessage;
  String? get successMessage => _successMessage;

  // ================= PRIVATE =================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    _successMessage = null; // Clear success when error occurs
    notifyListeners();
  }

  void _setSuccess(String? message) {
    _successMessage = message;
    _error = null; // Clear error when success occurs
    notifyListeners();
  }

  // ================= VALIDATION =================
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email address is required';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null; // Valid email
  }

  // ================= GET EMAIL =================
  Future<void> fetchEmail() async {
    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    try {
      final result = await _repo.getEmail();

      // adjust based on API response structure
      _email = result['data']?['email'];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ================= UPDATE EMAIL =================
  Future<bool> updateEmail(String email) async {
    // Validate email before making API call
    final validationError = validateEmail(email);
    if (validationError != null) {
      _setError(validationError);
      return false;
    }

    _setLoading(true);
    _setError(null);
    _setSuccess(null);

    try {
      final result = await _repo.updateEmail(email: email);

      if (result['status'] == true) {
        _email = email;
        _setSuccess('Email updated successfully!');
        return true;
      } else {
        _setError(result['message'] ?? 'Failed to update email');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ================= CLEAR =================
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
