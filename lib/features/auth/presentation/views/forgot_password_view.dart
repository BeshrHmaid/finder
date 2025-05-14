import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRouter.kVerifyOtpView);
                        },
                        text: 'Send Verification Code',
                        // rowChild:  const Text('Send Verification Code'),
                      ),
                    ),
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
