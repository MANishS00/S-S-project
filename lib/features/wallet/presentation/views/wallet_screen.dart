import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/wallet_viewmodel.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _withdrawFormKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      walletVM.fetchWalletBalance();
      walletVM.fetchPayoutRequests();
      walletVM.fetchWalletTransactions();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _showWithdrawDialog() {
    bool isSubmitting = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Request Withdrawal'),
              content: Form(
                key: _withdrawFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _amountController,
                      decoration:
                          const InputDecoration(labelText: 'Amount (Rs)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      enabled: !isSubmitting,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _upiIdController,
                      decoration: const InputDecoration(
                          labelText: 'UPI ID (e.g. user@paytm)'),
                      enabled: !isSubmitting,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter UPI ID';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (_withdrawFormKey.currentState?.validate() ??
                              false) {
                            setDialogState(() {
                              isSubmitting = true;
                            });

                            final amount = double.parse(_amountController.text);
                            final upiId = _upiIdController.text;
                            final walletVM = Provider.of<WalletViewModel>(
                                context,
                                listen: false);
                            final messenger = ScaffoldMessenger.of(context);
                            final navigator = Navigator.of(context);

                            try {
                              await walletVM.requestWithdrawal(amount, upiId);
                              navigator.pop(); // Dismiss dialog on success
                              messenger.showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Withdrawal request submitted successfully')),
                              );
                              _amountController.clear();
                              _upiIdController.clear();
                            } catch (e) {
                              setDialogState(() {
                                isSubmitting = false;
                              });
                              messenger.showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error requesting withdrawal: $e')),
                              );
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletVM = Provider.of<WalletViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF4EEFF),
        appBar: AppBar(
          title: const Text('My Wallet'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Transactions'),
              Tab(text: 'Payout Requests'),
            ],
          ),
        ),
        body: walletVM.isLoading && walletVM.balance == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Balance Header Card
                  Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    color: const Color(0xffDCD6F7),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('Available Balance',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            'Rs ${walletVM.balance?.availableBalance.toStringAsFixed(2) ?? "0.00"}',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text('Total Balance',
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                    'Rs ${walletVM.balance?.balance.toStringAsFixed(2) ?? "0.00"}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('Pending Balance',
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                    'Rs ${walletVM.balance?.pendingBalance.toStringAsFixed(2) ?? "0.00"}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff424874),
                            ),
                            onPressed: _showWithdrawDialog,
                            icon: const Icon(Icons.account_balance_wallet,
                                color: Colors.white),
                            label: const Text('Withdraw Funds',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab View for Payouts / Transactions
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Transactions Tab
                        walletVM.transactions.isEmpty
                            ? const Center(child: Text('No transactions yet'))
                            : ListView.builder(
                                itemCount: walletVM.transactions.length,
                                itemBuilder: (context, index) {
                                  final tx = walletVM.transactions[index];
                                  final isCredit =
                                      tx.transactionType == 'credit';
                                  return ListTile(
                                    leading: Icon(
                                      isCredit
                                          ? Icons.add_circle
                                          : Icons.remove_circle,
                                      color:
                                          isCredit ? Colors.green : Colors.red,
                                    ),
                                    title: Text(tx.description),
                                    subtitle: Text(tx.timestamp != null
                                        ? tx.timestamp!.toLocal().toString()
                                        : ''),
                                    trailing: Text(
                                      '${isCredit ? "+" : "-"} Rs ${tx.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isCredit
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),

                        // Payout Requests Tab
                        walletVM.payoutRequests.isEmpty
                            ? const Center(
                                child: Text('No payout requests yet'))
                            : ListView.builder(
                                itemCount: walletVM.payoutRequests.length,
                                itemBuilder: (context, index) {
                                  final pr = walletVM.payoutRequests[index];
                                  Color statusColor = Colors.orange;
                                  if (pr.status == 'approved' ||
                                      pr.status == 'paid') {
                                    statusColor = Colors.green;
                                  } else if (pr.status == 'rejected') {
                                    statusColor = Colors.red;
                                  }
                                  return ListTile(
                                    title: Text(
                                        'Withdrawal of Rs ${pr.amount.toStringAsFixed(2)}'),
                                    subtitle: Text(
                                        'UPI: ${pr.upiId}\nDate: ${pr.createdAt != null ? pr.createdAt!.toLocal().toString() : ""}'),
                                    trailing: Chip(
                                      label: Text(
                                        pr.statusDisplay,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      backgroundColor: statusColor,
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
