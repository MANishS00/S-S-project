import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/wallet_viewmodel.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';

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
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      if (authVM.isAuthenticated) {
        final walletVM = Provider.of<WalletViewModel>(context, listen: false);
        walletVM.fetchWalletBalance();
        walletVM.fetchPayoutRequests();
        walletVM.fetchWalletTransactions();
      }
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
    final authVM = Provider.of<AuthViewModel>(context);
    if (!authVM.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text('My Wallet'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text('Please log in to view your wallet.',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final walletVM = Provider.of<WalletViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF121212),
          centerTitle: true,
          title: const Text(
            "My Wallet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade400,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: "Transactions"),
                  Tab(text: "Payout Requests"),
                ],
              ),
            ),
          ),
        ),
        body: walletVM.isLoading && walletVM.balance == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Balance Header Card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.black45,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Available Balance",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                                                  
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// Balance
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${walletVM.balance?.availableBalance.toStringAsFixed(2) ?? "0.00"}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                             const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Total Balance",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "₹ ${walletVM.balance?.balance.toStringAsFixed(2) ?? "0.00"}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white24,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Pending",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "₹ ${walletVM.balance?.pendingBalance.toStringAsFixed(2) ?? "0.00"}",
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _showWithdrawDialog,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_upward_rounded),
                            label: const Text(
                              "Withdraw Funds",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab View for Payouts / Transactions
                  Expanded(
                    child: TabBarView(
                      children: [
                        /// =========================
                        /// Transactions Tab
                        /// =========================
                        walletVM.transactions.isEmpty
                            ? const Center(
                                child: Text(
                                  "No transactions yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: walletVM.transactions.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final tx = walletVM.transactions[index];
                                  final isCredit =
                                      tx.transactionType == "credit";

                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 26,
                                          backgroundColor: isCredit
                                              ? Colors.green.withOpacity(.12)
                                              : Colors.red.withOpacity(.12),
                                          child: Icon(
                                            isCredit
                                                ? Icons.arrow_downward_rounded
                                                : Icons.arrow_upward_rounded,
                                            color: isCredit
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        /// Description & Date
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tx.description,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                tx.timestamp != null
                                                    ? tx.timestamp!
                                                        .toLocal()
                                                        .toString()
                                                        .substring(0, 16)
                                                    : "",
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// Amount
                                        Text(
                                          "${isCredit ? "+" : "-"} ₹${tx.amount.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: isCredit
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                        /// =========================
                        /// Payout Requests Tab
                        /// =========================
                        walletVM.payoutRequests.isEmpty
                            ? const Center(
                                child: Text(
                                  "No payout requests yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: walletVM.payoutRequests.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final pr = walletVM.payoutRequests[index];

                                  Color statusColor = Colors.orange;

                                  if (pr.status == "approved" ||
                                      pr.status == "paid") {
                                    statusColor = Colors.green;
                                  } else if (pr.status == "rejected") {
                                    statusColor = Colors.red;
                                  }

                                  return Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.15),
                                          blurRadius: 12,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        /// Header
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.indigo
                                                  .withOpacity(.12),
                                              child: const Icon(
                                                Icons
                                                    .account_balance_wallet_outlined,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            const Expanded(
                                              child: Text(
                                                "Withdrawal Request",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Chip(
                                              backgroundColor: statusColor,
                                              label: Text(
                                                pr.statusDisplay,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 18),

                                        /// Amount
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Amount",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              "₹${pr.amount.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const Divider(height: 28),

                                        /// UPI
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.account_circle_outlined,
                                              size: 18,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                pr.upiId,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),

                                        /// Date
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 18,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                pr.createdAt != null
                                                    ? pr.createdAt!
                                                        .toLocal()
                                                        .toString()
                                                        .substring(0, 16)
                                                    : "",
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
