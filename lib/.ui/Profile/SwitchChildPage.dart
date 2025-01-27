import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/child/child_bloc.dart';
import '../../bloc/child/child_event.dart';
import '../../bloc/child/child_state.dart';
import '../../bloc/food/food_bloc.dart';
import '../../bloc/food/food_event.dart';
import '../../model/child.dart';
import '../../model/patient.dart';

import '../../database/database_patient.dart';
import '../../database/database_allergy.dart';
import 'AddChildPage.dart';
import 'EditChildPage.dart';

class SwitchChildPage extends StatefulWidget {
  const SwitchChildPage({super.key});

  @override
  State<SwitchChildPage> createState() => _SwitchChildPageState();
}

class _SwitchChildPageState extends State<SwitchChildPage> {
  Child? _selectedChild;
  AuthBloc? authBloc;
  ChildBloc? childBloc;
  FoodBloc? foodBloc;
  final PatientSqflite patientSqflite = PatientSqflite();
  final AllergySqflite allergySqflite = AllergySqflite();

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

  Widget _buildAllergiesList(String childId, Color genderColor) {
    return FutureBuilder<List<Patient>>(
      future: patientSqflite.getPatientByChildId(childId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: genderColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: genderColor.withOpacity(0.1),
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
                        color: genderColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.health_and_safety_outlined,
                    size: 22,
                    color: genderColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Don\'t have any allergies',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return FutureBuilder<List<Widget>>(
          future: Future.wait(
            snapshot.data!.map((patient) async {
              final allergy =
                  await AllergySqflite().getAllergyById(patient.allergyId);
              if (allergy == null) return Container();

              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: genderColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: genderColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: genderColor.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.medical_services_outlined,
                            size: 16,
                            color: genderColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          allergy.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: genderColor.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.whereType<Container>().toList(),
              ),
            );
          },
        );
      },
    );
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: genderColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditChildPage(child: child),
                      ),
                    ).then((value) {
                      if (value == true) {
                        // Refresh data setelah edit
                        childBloc?.add(LoadChildEvent(childId: child.id));
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 16),
                const Text(
                  'Allergies',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildAllergiesList(child.id, genderColor),
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
      child: Dismissible(
        key: Key(child.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Konfirmasi Hapus'),
                content:
                    Text('Apakah Anda yakin ingin menghapus ${child.name}?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) async {
          childBloc?.add(DeleteChildEvent(child.id));
          foodBloc?.add(DeleteMealEvent(child.id));
        },
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
            icon: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 24,
                color: Colors.black87,
              ),
            ),
            onPressed: () {
              if (_selectedChild != null) {
                childBloc?.add(LoadChildEvent(childId: _selectedChild!.id));
              }
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddChildPage()),
                  );
                },
                tooltip: 'Tambah Anak',
              ),
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! LoginAuthState) {
              return const Center(child: Text('Please login first'));
            }

            return BlocConsumer<ChildBloc, ChildState>(
              listener: (context, state) {
                if (state is LoadChildState) {}
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
                            'Current child',
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
                            'Select other child',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        FutureBuilder<List<Child>>(
                          future: childBloc?.childSqflite
                              .getChildByUserId(authState.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('No child'),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddChildPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.person_add),
                                      label: const Text('Add Child'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final otherChildren = snapshot.data!
                                .where(
                                    (child) => child.id != childState.child.id)
                                .toList();

                            if (otherChildren.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No other children'),
                              );
                            }

                            return ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: otherChildren.length,
                              itemBuilder: (context, index) {
                                return _buildChildItem(
                                  otherChildren[index],
                                  (childId) async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        'selectedChildId', childId);

                                    if (!mounted) return;
                                    childBloc
                                        ?.add(LoadChildEvent(childId: childId));
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
                                  _getGenderColor(childState.child.gender)
                                      .withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      _getGenderColor(childState.child.gender)
                                          .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'selectedChildId', childState.child.id);

                                if (!mounted) return;
                                _selectedChild = childState.child;
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Confirm",
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

                return const Center(child: Text('No child'));
              },
            );
          },
        ),
      ),
    );
  }
}
