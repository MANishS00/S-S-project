import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/config.dart';
import '../../../../core/network/logging_http_client.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../data/models/wallet_models.dart';

class WalletRepositoryImpl implements WalletRepository {
  final http.Client client;

  WalletRepositoryImpl({http.Client? client}) : client = client ?? LoggingHttpClient();

  @override
  Future<WalletBalanceModel> fetchWalletBalance(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/wallet/balance/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return WalletBalanceModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load wallet balance: ${response.body}');
    }
  }

  @override
  Future<List<PayoutRequestModel>> fetchPayoutRequests(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/wallet/payouts/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      List<dynamic> list;
      if (decoded is Map) {
        list = decoded['results'] ?? [];
      } else if (decoded is List) {
        list = decoded;
      } else {
        list = [];
      }
      return list.map((e) => PayoutRequestModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load payout requests: ${response.body}');
    }
  }

  @override
  Future<List<WalletTransactionModel>> fetchWalletTransactions(String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/wallet/transactions/');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      List<dynamic> list;
      if (decoded is Map) {
        list = decoded['results'] ?? [];
      } else if (decoded is List) {
        list = decoded;
      } else {
        list = [];
      }
      return list.map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load wallet transactions: ${response.body}');
    }
  }

  @override
  Future<void> requestWithdrawal(double amount, String upiId, String? requestId, String token) async {
    final url = Uri.parse('${Config.baseUrl}/api/wallet/withdraw/');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'amount': amount.toStringAsFixed(2),
        'upi_id': upiId,
        if (requestId != null) 'request_id': requestId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to request wallet withdrawal: ${response.body}');
    }
  }
}
