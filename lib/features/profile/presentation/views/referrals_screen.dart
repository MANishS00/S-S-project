import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

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
      Provider.of<ProfileViewModel>(context, listen: false).fetchReferrals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      appBar: AppBar(
        title: const Text('My Referrals'),
      ),
      body: profileVM.referrals.isEmpty
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
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
    );
  }
}
