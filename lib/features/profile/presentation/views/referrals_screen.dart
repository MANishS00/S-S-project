import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../../data/models/referral_tree_model.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({super.key});

  @override
  _ReferralsScreenState createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      profileVM.fetchReferrals();
      profileVM.fetchReferralTree();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF4EEFF),
        appBar: AppBar(
          title: const Text('My Referrals'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Referral List'),
              Tab(text: 'Tree View'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Referral List Tab
            profileVM.referrals.isEmpty
                ? const Center(
                    child: Text(
                      'You have not referred anyone yet.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: profileVM.referrals.length,
                    itemBuilder: (context, index) {
                      final ref = profileVM.referrals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xffDCD6F7),
                            child: Icon(Icons.person, color: Color(0xff424874)),
                          ),
                          title: Text(ref.fullName),
                          subtitle: Text(ref.email),
                          trailing: ref.dateJoined != null
                              ? Text(
                                  'Joined: ${ref.dateJoined!.toLocal().toString().substring(0, 10)}',
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                        ),
                      );
                    },
                  ),

            // Tree View Tab
            profileVM.referralTree.isEmpty
                ? const Center(
                    child: Text(
                      'No tree data available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: profileVM.referralTree.length,
                    itemBuilder: (context, index) {
                      final rootNode = profileVM.referralTree[index];
                      return ReferralNodeWidget(node: rootNode);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class ReferralNodeWidget extends StatelessWidget {
  final ReferralTreeModel node;
  final int depth;

  const ReferralNodeWidget({super.key, required this.node, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    if (node.children.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: 12.0 * depth),
        child: ListTile(
          leading: const Icon(Icons.person_outline, color: Colors.grey),
          title: Text(node.name),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 12.0 * depth),
      child: ExpansionTile(
        leading: const Icon(Icons.person, color: Color(0xff424874)),
        title: Text(
          node.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: node.children
            .map((child) => ReferralNodeWidget(node: child, depth: depth + 1))
            .toList(),
      ),
    );
  }
}
