import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../domain/entities/sign_in_params.dart';
import '../../domain/use_cases/sign_in_use_case.dart';

/// Presentation layer - ViewModel (UI state management)
class AuthViewModel extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthViewModel({required SignInUseCase signInUseCase})
      : _signInUseCase = signInUseCase;

  // Getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> signIn() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final params = SignInParams(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        deviceToken: 'wqwqw', // TODO: Get actual device token
        deviceType: Platform.isAndroid ? 'android' : 'ios',
      );

      final result = await _signInUseCase.execute(params);

      _isLoading = false;

      if (result.isSuccess) {
        _isAuthenticated = true;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.message;
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

