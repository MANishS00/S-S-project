import '../../data/models/wallet_models.dart';

abstract class WalletRepository {
  Future<WalletBalanceModel> fetchWalletBalance(String token);
  Future<List<PayoutRequestModel>> fetchPayoutRequests(String token);
  Future<List<WalletTransactionModel>> fetchWalletTransactions(String token);
  Future<void> requestWithdrawal(double amount, String upiId, String? requestId, String token);
}
