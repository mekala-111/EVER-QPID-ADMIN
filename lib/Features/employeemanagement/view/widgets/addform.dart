import 'package:flutter/material.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:everqpidadmin/Features/employeemanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Features/employeemanagement/model/model.dart';
import 'package:provider/provider.dart';

class AddEditEmployeeForm extends StatefulWidget {
  final Employee? employee; // null for add, non-null for edit

  const AddEditEmployeeForm({super.key, this.employee});

  @override
  State<AddEditEmployeeForm> createState() => _AddEditEmployeeFormState();
}

class _AddEditEmployeeFormState extends State<AddEditEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  String? selectedRole;
  String? selectedAuthorityLevel;

  final List<String> roles = [
    // 'Manager',
    'Chat Support',
    'Customer Support',
    // 'Marketing',
  ];

  final List<String> authorityLevels = [
    'Full Access',
    'View Access',
    'Edit Access',
    'View & Edit Access',
  ];

  bool get isEditMode => widget.employee != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      // Populate fields for edit mode
      nameCtrl.text = widget.employee!.name;
      emailCtrl.text = widget.employee!.email;
      selectedRole = widget.employee!.role;
      selectedAuthorityLevel = widget.employee!.authorityLevel;
    }
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedAuthorityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an authority level'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<EmployeeViewModel>();
    bool success;

    if (isEditMode) {
      // Edit mode
      success = await viewModel.editEmployee(
        context,
        employeeId: widget.employee!.id,
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        role: selectedRole!,
        authorityLevel: selectedAuthorityLevel!,
      );
    } else {
      // Add mode
      success = await viewModel.addEmployee(
        context,
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        role: selectedRole!,
        authorityLevel: selectedAuthorityLevel!,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeViewModel>(
      builder: (context, viewModel, _) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditMode ? "Edit Employee" : "Add Employee",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed:
                        viewModel.loading ? null : () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Name
              TextFormField(
                controller: nameCtrl,
                enabled: !viewModel.loading,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Email
              TextFormField(
                controller: emailCtrl,
                enabled: !viewModel.loading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Role Dropdown
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: "Role",
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                items: roles
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: viewModel.loading
                    ? null
                    : (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Role is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Authority Level Dropdown
              DropdownButtonFormField<String>(
                initialValue: selectedAuthorityLevel,
                decoration: InputDecoration(
                  labelText: "Authority Level",
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                items: authorityLevels
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: viewModel.loading
                    ? null
                    : (value) {
                        setState(() {
                          selectedAuthorityLevel = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Authority level is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: viewModel.loading ? null : _handleSubmit,
                  child: viewModel.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditMode ? "Update Employee" : "Add Employee",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
