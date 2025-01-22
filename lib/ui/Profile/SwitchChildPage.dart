import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/child/child_bloc.dart';
import '../../bloc/child/child_event.dart';
import '../../bloc/child/child_state.dart';
import '../../model/child.dart';

class SwitchChildPage extends StatefulWidget {
  const SwitchChildPage({super.key});

  @override
  State<SwitchChildPage> createState() => _SwitchChildPageState();
}

class _SwitchChildPageState extends State<SwitchChildPage> {
  Child? _selectedChild;
  AuthBloc? authBloc;
  ChildBloc? childBloc;

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
    childBloc = context.read<ChildBloc>();
    if (childBloc?.state is LoadChildState) {
      _selectedChild = (childBloc?.state as LoadChildState).child;
    }
  }

  IconData _getGenderIcon(String gender) {
    return gender.toLowerCase() == 'male'
        ? Icons.male_rounded
        : Icons.female_rounded;
  }

  Color _getGenderColor(String gender) {
    return gender.toLowerCase() == 'male'
        ? const Color(0xFF2196F3) // Material Blue
        : const Color(0xFFE91E63); // Material Pink
  }

  String _getProfileImage(String gender) {
    return gender.toLowerCase() == 'male'
        ? 'assets/images/male.png'
        : 'assets/images/female.png';
  }

  Widget _buildSelectedChild(Child child) {
    final genderColor = _getGenderColor(child.gender);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: genderColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  genderColor.withOpacity(0.1),
                  genderColor.withOpacity(0.2),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: genderColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: genderColor.withOpacity(0.1),
                    child: ClipOval(
                      child: Image.asset(
                        _getProfileImage(child.gender),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: genderColor.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getGenderIcon(child.gender),
                              size: 16,
                              color: genderColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              child.gender,
                              style: TextStyle(
                                color: genderColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow(
                  'Umur',
                  '${child.age} tahun',
                  Icons.cake_outlined,
                  genderColor,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  'Berat Badan',
                  '${child.weight} kg',
                  Icons.monitor_weight_outlined,
                  genderColor,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  'Tinggi Badan',
                  '${child.height} cm',
                  Icons.height_outlined,
                  genderColor,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  'Target',
                  child.goal,
                  Icons.flag_outlined,
                  genderColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildItem(Child child, Function(String) onSelect) {
    final genderColor = _getGenderColor(child.gender);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: genderColor.withOpacity(0.1),
              child: ClipOval(
                child: Image.asset(
                  _getProfileImage(child.gender),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.change_circle_outlined,
                  size: 14,
                  color: genderColor,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          child.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  _getGenderIcon(child.gender),
                  size: 16,
                  color: genderColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${child.age} tahun',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Target: ${child.goal}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: genderColor,
          size: 20,
        ),
        onTap: () => onSelect(child.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedChild != null) {
          childBloc?.add(LoadChildEvent(childId: _selectedChild!.id));
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_selectedChild != null) {
                childBloc?.add(LoadChildEvent(childId: _selectedChild!.id));
              }
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Pilih Anak',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! LoginAuthState) {
              return const Center(child: Text('Silakan login terlebih dahulu'));
            }

            return BlocConsumer<ChildBloc, ChildState>(
              listener: (context, state) {
                if (state is LoadChildState) {
                }
              },
              builder: (context, childState) {
                if (childState is LoadingChildState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (childState is ErrorChildState) {
                  return Center(child: Text(childState.message));
                }

                if (childState is LoadChildState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Anak yang dipilih saat ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildSelectedChild(childState.child),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Pilih anak lain',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        FutureBuilder<List<Child>>(
                          future: childBloc?.childSqflite.getChildByUserId(authState.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Tidak ada anak lain'));
                            }

                            final otherChildren = snapshot.data!
                                .where((child) => child.id != childState.child.id)
                                .toList();

                            if (otherChildren.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Tidak ada anak lain'),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: otherChildren.length,
                              itemBuilder: (context, index) {
                                return _buildChildItem(
                                  otherChildren[index],
                                  (childId) async {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('selectedChildId', childId);
                                    
                                    if (!mounted) return;
                                    childBloc?.add(LoadChildEvent(childId: childId));
                                  },
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  _getGenderColor(childState.child.gender),
                                  _getGenderColor(childState.child.gender).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _getGenderColor(childState.child.gender).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('selectedChildId', childState.child.id);
                                
                                if (!mounted) return;
                                _selectedChild = childState.child;
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Confirm Selection: ${childState.child.name}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }

                return const Center(child: Text('Tidak ada data anak'));
              },
            );
          },
        ),
      ),
    );
  }
}
