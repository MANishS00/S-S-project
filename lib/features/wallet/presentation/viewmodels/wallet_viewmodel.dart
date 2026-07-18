import 'package:flutter/material.dart';
import '../../data/models/wallet_models.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../../../core/utils/token_helper.dart';

class WalletViewModel with ChangeNotifier {
  final WalletRepository _repository;

  WalletBalanceModel? _balance;
  List<PayoutRequestModel> _payoutRequests = [];
  List<WalletTransactionModel> _transactions = [];
  bool _isLoading = false;

  WalletViewModel({WalletRepository? repository})
      : _repository = repository ?? WalletRepositoryImpl();

  WalletBalanceModel? get balance => _balance;
  List<PayoutRequestModel> get payoutRequests => _payoutRequests;
  List<WalletTransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> fetchWalletBalance() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _balance = await _repository.fetchWalletBalance(token);
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPayoutRequests() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _payoutRequests = await _repository.fetchPayoutRequests(token);
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWalletTransactions() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _repository.fetchWalletTransactions(token);
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestWithdrawal(double amount, String upiId, {String? requestId}) async {
    final token = await TokenHelper.getValidToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.requestWithdrawal(amount, upiId, requestId, token);
      await fetchWalletBalance();
      await fetchPayoutRequests();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
