import 'package:flutter/material.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:everqpidadmin/Features/Ticketmanagement/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Data/LocaStorage/loggedin_user.dart';
import 'package:provider/provider.dart';

class AddTicketForm extends StatefulWidget {
  const AddTicketForm({super.key});

  @override
  State<AddTicketForm> createState() => _AddTicketFormState();
}

class _AddTicketFormState extends State<AddTicketForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  String? selectedCategory;

  final List<String> categories = [
    'Report Abuse',
    'Safety',
    'Profile Verification',
    'Payment',
    'Subscription',
    'Chat Issue',
    'Match Issue',
    'Account',
    'General',
  ];

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    subjectCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRaiseTicket() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get adminId from LoggedInUser (adjust this based on your actual implementation)
    final adminId = LoggedInUser.id ?? '';

    if (adminId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin ID not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<TicketsViewModel>();

    final success = await viewModel.createTicket(
      context,
      adminId: adminId,
      email: emailCtrl.text.trim(),
      category: selectedCategory!,
      subject: subjectCtrl.text.trim(),
      description: descriptionCtrl.text.trim(),
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketsViewModel>(
      builder: (context, viewModel, _) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Ticket",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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

              /// Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                items: categories
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
                          selectedCategory = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Subject
              TextFormField(
                controller: subjectCtrl,
                enabled: !viewModel.loading,
                decoration: InputDecoration(
                  labelText: "Subject",
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Subject is required';
                  }
                  if (value.trim().length < 5) {
                    return 'Subject must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Description (Big TextBox)
              TextFormField(
                controller: descriptionCtrl,
                enabled: !viewModel.loading,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const Spacer(),

              /// Full Width Button
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
                  onPressed: viewModel.loading ? null : _handleRaiseTicket,
                  child: viewModel.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Raise Ticket",
                          style: TextStyle(
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
