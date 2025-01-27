import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;

  const ChildForm({
    super.key,
    this.formKey,
  });

  @override
  State<ChildForm> createState() => _ChildFormState();
}

class _ChildFormState extends State<ChildForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  String? selectedGender;

  Future<void> saveChildData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('child_name', nameController.text);
    await prefs.setInt('child_age', int.parse(ageController.text));
    await prefs.setDouble('child_weight', double.parse(weightController.text));
    await prefs.setDouble('child_height', double.parse(heightController.text));
    await prefs.setString('child_gender', selectedGender ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  bool validateForm() {
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select gender'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (formKey.currentState?.validate() ?? false) {
      saveChildData();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          _buildFormField(
            controller: nameController,
            label: 'Child Name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter child name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildFormField(
            controller: ageController,
            label: 'Age (years)',
            icon: Icons.cake,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter age';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildGenderSelection(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  controller: weightController,
                  label: 'Weight (kg)',
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormField(
                  controller: heightController,
                  label: 'Height (cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
                isSelected: selectedGender == 'Male',
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    selectedGender = selectedGender == 'Male' ? null : 'Male';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderCard(
                icon: Icons.female,
                label: 'Female',
                isSelected: selectedGender == 'Female',
                color: Colors.red,
                onTap: () {
                  setState(() {
                    selectedGender =
                        selectedGender == 'Female' ? null : 'Female';
                  });
                },
              ),
            ),
          ],
        ),
        if (selectedGender == null)
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
}
