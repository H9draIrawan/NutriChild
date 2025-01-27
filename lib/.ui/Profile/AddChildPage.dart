import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/child/child_bloc.dart';
import '../../bloc/child/child_event.dart';
import '../../model/child.dart';

class AddChildPage extends StatefulWidget {
  const AddChildPage({super.key});

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGender;
  String _selectedGoal = 'Eat healthy';

  final List<String> _goals = [
    'Eat healthy',
    'Loose weight',
    'Build muscles',
  ];

  // Tambahkan list alergi
  final List<Map<String, dynamic>> allergies = [
    {
      'icon': '🥚',
      'name': 'Egg',
      'isSelected': false,
      'color': Colors.orange[50],
      'selectedColor': Colors.orange[100]
    },
    {
      'icon': '🥛',
      'name': 'Milk',
      'isSelected': false,
      'color': Colors.blue[50],
      'selectedColor': Colors.blue[100]
    },
    {
      'icon': '🥜',
      'name': 'Peanut',
      'isSelected': false,
      'color': Colors.brown[50],
      'selectedColor': Colors.brown[100]
    },
    {
      'icon': '🌱',
      'name': 'Soybean',
      'isSelected': false,
      'color': Colors.green[50],
      'selectedColor': Colors.green[100]
    },
    {
      'icon': '🐟',
      'name': 'Fish',
      'isSelected': false,
      'color': Colors.blue[50],
      'selectedColor': Colors.blue[100]
    },
    {
      'icon': '🌾',
      'name': 'Wheat',
      'isSelected': false,
      'color': Colors.amber[50],
      'selectedColor': Colors.amber[100]
    },
    {
      'icon': '🥬',
      'name': 'Celery',
      'isSelected': false,
      'color': Colors.lightGreen[50],
      'selectedColor': Colors.lightGreen[100]
    },
    {
      'icon': '🦐',
      'name': 'Crustacean',
      'isSelected': false,
      'color': Colors.red[50],
      'selectedColor': Colors.red[100]
    },
    {
      'icon': '🌶️',
      'name': 'Mustard',
      'isSelected': false,
      'color': Colors.yellow[50],
      'selectedColor': Colors.yellow[100]
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: Colors.green[600]),
          suffixText: suffix,
          suffixStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Gender',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildGenderCard(
                icon: Icons.male,
                label: 'Male',
                isSelected: _selectedGender == 'Male',
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _selectedGender = _selectedGender == 'Male' ? null : 'Male';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderCard(
                icon: Icons.female,
                label: 'Female',
                isSelected: _selectedGender == 'Female',
                color: Colors.pink,
                onTap: () {
                  setState(() {
                    _selectedGender =
                        _selectedGender == 'Female' ? null : 'Female';
                  });
                },
              ),
            ),
          ],
        ),
        if (_selectedGender == null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: Text(
              'Please select gender',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[400],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGenderCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? color : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modifikasi _buildAllergyGrid()
  Widget _buildAllergyGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Alergi',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 400 ? 4 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: allergies.length,
              itemBuilder: (context, index) {
                final isSelected = allergies[index]['isSelected'] as bool;

                return InkWell(
                  onTap: () {
                    setState(() {
                      allergies[index]['isSelected'] = !isSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? allergies[index]['selectedColor']
                          : allergies[index]['color'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green
                            : Colors.grey.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          allergies[index]['icon']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            allergies[index]['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.green[700]
                                  : Colors.black54,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Colors.black87,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! LoginAuthState) {
            return const Center(child: Text('Please login first'));
          }

          final ChildBloc childBloc = BlocProvider.of<ChildBloc>(context);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green.shade50],
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Basic Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Complete your child\'s data to create an appropriate profile',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildFormField(
                                    controller: _nameController,
                                    label: 'Child Name',
                                    icon: Icons.person,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name cannot be empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _buildGenderSelection(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Physical Info Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Physical Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Physical data is needed to customize nutrition recommendations',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildFormField(
                                    controller: _ageController,
                                    label: 'Age (years)',
                                    icon: Icons.cake,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Age cannot be empty';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Age must be a number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 80,
                                          child: _buildFormField(
                                            controller: _weightController,
                                            label: 'Weight',
                                            icon: Icons.monitor_weight,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            suffix: 'kg',
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Required';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Invalid';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: SizedBox(
                                          height: 80,
                                          child: _buildFormField(
                                            controller: _heightController,
                                            label: 'Height',
                                            icon: Icons.height,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            suffix: 'cm',
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Required';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Invalid';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Goals & Allergies Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Goals & Allergies',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Select goals and allergies to customize the menu',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedGoal,
                                      decoration: InputDecoration(
                                        labelText: 'Target',
                                        labelStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.flag,
                                            color: Colors.green[600]),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                      ),
                                      items: _goals.map((String goal) {
                                        return DropdownMenuItem<String>(
                                          value: goal,
                                          child: Text(goal),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedGoal = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildAllergyGrid(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Save Button
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade600,
                                    Colors.green.shade400,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      _selectedGender != null) {
                                    // Tampilkan loading indicator
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );

                                    try {
                                      final child = Child(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        userId: authState.id,
                                        name: _nameController.text,
                                        gender: _selectedGender!,
                                        age: int.parse(_ageController.text),
                                        weight: double.parse(
                                            _weightController.text),
                                        height: double.parse(
                                            _heightController.text),
                                        goal: _selectedGoal,
                                      );

                                      childBloc.add(SaveChildEvent(
                                          id: child.id,
                                          userId: authState.id,
                                          name: _nameController.text,
                                          age: int.parse(_ageController.text),
                                          gender: _selectedGender!,
                                          weight: double.parse(
                                              _weightController.text),
                                          height: double.parse(
                                              _heightController.text),
                                          goal: _selectedGoal));

                                      // Dapatkan semua alergi yang dipilih
                                      final selectedAllergies = allergies
                                          .where((allergy) =>
                                              allergy['isSelected'] as bool)
                                          .map((a) => a['name'] as String)
                                          .toList();

                                      // Simpan alergi satu per satu dengan delay
                                      for (var allergyName
                                          in selectedAllergies) {
                                        childBloc.add(SaveAllergyEvent(
                                          name: allergyName,
                                          childId: child.id,
                                        ));

                                        // Tambahkan delay kecil antara setiap penyimpanan
                                        await Future.delayed(
                                            const Duration(milliseconds: 100));
                                      }

                                      // Tambahkan delay sebelum berpindah halaman
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      if (!mounted) return;

                                      // Tutup dialog loading
                                      Navigator.pop(context);

                                      // Load child dan kembali ke halaman sebelumnya
                                      context.read<ChildBloc>().add(
                                          LoadChildEvent(childId: child.id));
                                      Navigator.pop(context);
                                    } catch (e) {
                                      // Jika terjadi error, tutup dialog loading dan tampilkan pesan error
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Error: ${e.toString()}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
