import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/ui/dialogs/dialogs.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final int _otpLength = 6;
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];
  bool _isLoading = false;
  int _resendCountdown = 30;
  bool _resendDisabled = true;
  String? _email;

  @override
  void initState() {
    super.initState();

    // Initialize focus nodes and controllers
    for (int i = 0; i < _otpLength; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
    }

    // Start countdown for resend button
    _startResendTimer();
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          _resendDisabled = false;
        });
      }
    });
  }

  String _getOtpValue() {
    return _controllers.map((controller) => controller.text).join();
  }

  bool _isOtpComplete() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _verifyOtp() async {
    if (!_isOtpComplete()) {
      Dialogs.showErrorSnackBar(
          message: 'Please enter the complete verification code',
          context: context,
          typeSnackBar: AnimatedSnackBarType.error);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, any OTP is considered valid
      final otpValue = _getOtpValue();
      print('Verifying OTP: $otpValue for email: $_email');

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Verification successful! Password reset link sent to your email.'),
            backgroundColor: Color(0xFF4C9F97),
          ),
        );

        // In a real app, this would navigate to reset password screen or login
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/forgot-password',
              (route) => false,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Please try again.'),
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

  void _resendCode() async {
    if (_resendDisabled) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('A new verification code has been sent to $_email'),
            backgroundColor: const Color(0xFF4C9F97),
          ),
        );

        // Reset the countdown
        setState(() {
          _resendCountdown = 30;
          _resendDisabled = true;
        });
        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        // title: const Text('Verification'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4C9F97),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C9F97).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      size: 40,
                      color: Color(0xFF4C9F97),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title and description
                  Text(
                    'Verification Code',
                    style: AppTextStyle.getRegularStyle(
                      color: Theme.of(context).colorScheme.themedBlack,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We\'ve sent a verification code to\n${_email ?? 'your email'}',
                    style: AppTextStyle.getRegularStyle(
                      color: AppColors.grey72,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // OTP Input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _otpLength,
                      (index) => _buildOtpTextField(index),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Verify button
                  const SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      // onPressed: _isLoading ? null : _verifyOtp,
                      text: 'Verify Code',
                    ),
                  ),

                  // Resend code option
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t receive the code? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: _isLoading || _resendDisabled
                              ? null
                              : _resendCode,
                          child: Text(
                            _resendDisabled
                                ? 'Resend in $_resendCountdown s'
                                : 'Resend Code',
                            style: TextStyle(
                              color: _resendDisabled
                                  ? Colors.grey
                                  : const Color(0xFF4C9F97),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(int index) {
    return Container(
      width: 45,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: _controllers[index].text.isNotEmpty
                  ? const Color(0xFF4C9F97)
                  : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4C9F97), width: 2),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move to next field
            if (index < _otpLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
              // Auto verify if all fields are filled
              if (_isOtpComplete()) {
                _verifyOtp();
              }
            }
          }
        },
        onTap: () {
          // Select all text when tapped (for easy overwriting)
          _controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[index].text.length,
          );
        },
      ),
    );
  }
}
