import 'package:flutter/material.dart';
import '../../domain/repositories/consultant_repository.dart';
import '../../data/repositories/consultant_repository_impl.dart';
import '../../../../core/utils/token_helper.dart';

class ConsultantViewModel with ChangeNotifier {
  final ConsultantRepository _repository;
  bool _isLoading = false;
  List<Map<String, dynamic>> _requests = [];

  ConsultantViewModel({ConsultantRepository? repository})
      : _repository = repository ?? ConsultantRepositoryImpl();

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get requests => _requests;

  Future<void> submitConsultantRequest({
    required String name,
    required String productService,
    required String mobileNumber,
    required String email,
    required String message,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.submitConsultantRequest(
        name: name,
        productService: productService,
        mobileNumber: mobileNumber,
        email: email,
        message: message,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConsultantRequests() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _requests = await _repository.fetchConsultantRequests(token);
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
