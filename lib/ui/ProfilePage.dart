import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'PROFILES',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
        ),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>?;
                    return ListView(
                      children: [
                        // Profile Header
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: const Color(0xFF1A1A1A),
                          child: Row(
                            children: [
                              // Profile Image
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red[100],
                                child: const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // User Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData?['username'] ?? 'User',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      userData?['email'] ?? 'email@gmail.com',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Text(
                                      'Registered Since Dec 2023',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Edit Icon
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Handle edit profile
                                },
                              ),
                            ],
                          ),
                        ),

                        // Menu Items
                        _buildMenuItem(
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.favorite_border,
                          title: 'My Wishlist',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.description_outlined,
                          title: 'My Prescription',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.science_outlined,
                          title: 'Your Lab Test',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.medical_services_outlined,
                          title: 'Doctor Consultation',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.payment_outlined,
                          title: 'Payment Methods',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Your Addresses',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Pill Reminder',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.people_outline,
                          title: 'Invite Friends',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () async {
                            // Handle logout
                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove('email');
                            prefs.remove('password');
                            BlocProvider.of<AuthBloc>(context)
                                .add(LogoutEvent());
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),

                        // Need Help Button
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Need Help?'),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
