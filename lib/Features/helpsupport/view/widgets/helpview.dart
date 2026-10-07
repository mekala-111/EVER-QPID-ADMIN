import 'package:everqpidadmin/Features/helpsupport/viewmodel/viewmodel.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpSupportBody extends StatefulWidget {
  const HelpSupportBody({super.key});

  @override
  State<HelpSupportBody> createState() => _HelpSupportBodyState();
}

class _HelpSupportBodyState extends State<HelpSupportBody> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEditingEmail = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HelpViewModel>();

    /// Sync controller when email changes
    if (!_isEditingEmail && vm.email != null) {
      _emailController.text = vm.email!;
    }

    return Container(
      padding: const EdgeInsets.only(left: 17, right: 20, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildEmailCard(vm),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return const Text(
      'Help & Support',
      style: TextStyle(
        color: Color(0xFF091128),
        fontSize: 29,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ================= CARD =================
  Widget _buildEmailCard(HelpViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE5E8EC)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditingEmail ? 'Update Email' : 'Email Address',
                  style: const TextStyle(
                    color: Color(0xFF091128),
                    fontSize: 17,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _isEditingEmail
                          ? _buildEmailTextField()
                          : _buildEmailDisplay(vm),
                    ),
                    const SizedBox(width: 10),
                    _buildActionButtons(vm),
                  ],
                ),
                // Error Message
                if (vm.error != null) ...[
                  const SizedBox(height: 10),
                  _buildMessageBox(
                    message: vm.error!,
                    isError: true,
                  ),
                ],
                // Success Message
                if (vm.successMessage != null) ...[
                  const SizedBox(height: 10),
                  _buildMessageBox(
                    message: vm.successMessage!,
                    isError: false,
                  ),
                ],
              ],
            ),
    );
  }

  // ================= MESSAGE BOX =================
  Widget _buildMessageBox({required String message, required bool isError}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isError ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color:
                    isError ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                fontSize: 13,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMAIL DISPLAY =================
  Widget _buildEmailDisplay(HelpViewModel vm) {
    return Text(
      vm.email ?? '--',
      style: const TextStyle(
        color: Color(0xFF67728D),
        fontSize: 14,
        fontFamily: 'Roboto',
      ),
    );
  }

  // ================= EMAIL FIELD =================
  Widget _buildEmailTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE4E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Enter email address',
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  // ================= BUTTONS =================
  Widget _buildActionButtons(HelpViewModel vm) {
    return Row(
      children: [
        if (_isEditingEmail) ...[
          GestureDetector(
            onTap: () {
              setState(() {
                _isEditingEmail = false;
                _emailController.text = vm.email ?? '';
              });
              vm.clearMessages(); // Clear any messages when canceling
            },
            child: _outlinedButton('Cancel'),
          ),
          const SizedBox(width: 8),
        ],
        GestureDetector(
          onTap: () async {
            if (_isEditingEmail) {
              final success =
                  await vm.updateEmail(_emailController.text.trim());

              if (success) {
                setState(() => _isEditingEmail = false);
              }
            } else {
              setState(() => _isEditingEmail = true);
              vm.clearMessages(); // Clear messages when starting to edit
            }
          },
          child: _filledButton(_isEditingEmail ? 'Save' : 'Edit'),
        ),
      ],
    );
  }

  // ================= BUTTON STYLES =================
  Widget _outlinedButton(String text) {
    return Container(
      height: 37,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF67728D)),
      ),
    );
  }

  Widget _filledButton(String text) {
    return Container(
      width: 82,
      height: 37,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
