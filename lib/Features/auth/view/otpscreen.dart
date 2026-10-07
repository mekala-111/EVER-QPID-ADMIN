import 'package:everqpidadmin/Features/auth/view_model/login_view_model.dart';
import 'package:everqpidadmin/Settings/utils/p_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Otpscreen extends StatefulWidget {
  final String email;
  const Otpscreen({super.key, required this.email});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: PColors.scaffoldColor2,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 480,
              minHeight: size.height,
            ),
            child: Center(
              child: Card(
                elevation: 0,
                color: PColors.colorFFFFFF,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(48),
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/name.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 48),

                        // Login Title
                        Text(
                          'Enter OTP',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: PColors.color000000,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),

                        // Welcome Text
                        Text(
                          'Enter OTP shared with your email',
                          style: TextStyle(
                            fontSize: 14,
                            color: PColors.color353534.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 32),

                        // OTP Field
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: PColors.color353534.withValues(alpha: 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    PColors.color353534.withValues(alpha: 0.2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    PColors.color353534.withValues(alpha: 0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: PColors.primaryColor,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: PColors.colorFFFFFF,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            //     .hasMatch(value)) {
                            //   return 'Please enter a valid email';
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password Field

                        // Login Button
                        Consumer<AuthViewModel>(
                          builder: (context, viewModel, child) {
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          await viewModel.verifyOtp(
                                            context: context,
                                            // email: ModalRoute.of(context)!
                                            //     .settings
                                            //     .arguments as String,
                                            email: widget.email,
                                            otp: _otpController.text.trim(),
                                          );
                                          if (!context.mounted) return;

                                          if (viewModel.loginErrorText !=
                                              null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  viewModel.loginErrorText!,
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PColors.primaryColor,
                                  foregroundColor: PColors.colorFFFFFF,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: viewModel.isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            PColors.colorFFFFFF,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
