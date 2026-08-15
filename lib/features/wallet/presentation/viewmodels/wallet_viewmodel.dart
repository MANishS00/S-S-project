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
  
  bool _isBalanceLoading = false;
  bool _isPayoutsLoading = false;
  bool _isTransactionsLoading = false;

  WalletViewModel({WalletRepository? repository})
      : _repository = repository ?? WalletRepositoryImpl();

  WalletBalanceModel? get balance => _balance;
  List<PayoutRequestModel> get payoutRequests => _payoutRequests;
  List<WalletTransactionModel> get transactions => _transactions;

  bool get isLoading => _isBalanceLoading || _isPayoutsLoading || _isTransactionsLoading;

  Future<void> fetchWalletBalance() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isBalanceLoading = true;
    notifyListeners();

    try {
      _balance = await _repository.fetchWalletBalance(token);
    } catch (e) {
      debugPrint('Error fetching wallet balance: $e');
    } finally {
      _isBalanceLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPayoutRequests() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isPayoutsLoading = true;
    notifyListeners();

    try {
      _payoutRequests = await _repository.fetchPayoutRequests(token);
    } catch (e) {
      debugPrint('Error fetching payout requests: $e');
    } finally {
      _isPayoutsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWalletTransactions() async {
    final token = await TokenHelper.getValidToken();
    if (token == null) return;

    _isTransactionsLoading = true;
    notifyListeners();

    try {
      _transactions = await _repository.fetchWalletTransactions(token);
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    } finally {
      _isTransactionsLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestWithdrawal(double amount, String upiId, {String? requestId}) async {
    final token = await TokenHelper.getValidToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    _isBalanceLoading = true;
    notifyListeners();

    try {
      await _repository.requestWithdrawal(amount, upiId, requestId, token);
      await fetchWalletBalance();
      await fetchPayoutRequests();
    } catch (e) {
      debugPrint('Error requesting withdrawal: $e');
      rethrow;
    } finally {
      _isBalanceLoading = false;
      notifyListeners();
    }
  }
}
