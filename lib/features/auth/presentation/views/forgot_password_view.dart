import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate API call with a delay
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification code sent to your email'),
              backgroundColor: Color(0xFF4C9F97),
            ),
          );

          // Navigate to OTP verification screen
          Navigator.pushNamed(
            context,
            '/otp-verification',
            arguments: _emailController.text,
          );
        }
      } catch (e) {
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text('Forgot Password'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4C9F97),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),

              // Title and description
              Text(
                'Forgot Your Password?',
                style: AppTextStyle.getRegularStyle(
                  color: Theme.of(context).colorScheme.themedBlack,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Enter your email address and we\'ll send you a verification code to reset your password.',
                style: AppTextStyle.getRegularStyle(
                  color: AppColors.grey72,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: AppTextStyle.getBoldStyle(
                        color: Theme.of(context).colorScheme.themedBlack,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      // autocorrect: false,
                      hintText: 'Enter your email address',
                      prefixIcon: const Icon(Icons.email_outlined),

                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Please enter your email address';
                        // }
                        // if (!EmailValidator.validate(value)) {
                        //   return 'Please enter a valid email address';
                        // }
                        return null;
                      },
                      // enabled: !_isLoading,
                    ),
                    SizedBox(height: 40.h),

                    // Submit button
                    const SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        // onPressed: _isLoading ? null : _submitForm,
                        text: 'Send Verification Code',
                        // rowChild:  const Text('Send Verification Code'),
                      ),
                    ),

                    // Back to login button
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //   child: Center(
                    //     child: TextButton(
                    //       onPressed: _isLoading
                    //           ? null
                    //           : () {
                    //               // In a real app, this would navigate to login screen
                    //               ScaffoldMessenger.of(context).showSnackBar(
                    //                 const SnackBar(
                    //                   content: Text('Navigate to login screen'),
                    //                 ),
                    //               );
                    //             },
                    //       child: const Text('Back to Login'),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
