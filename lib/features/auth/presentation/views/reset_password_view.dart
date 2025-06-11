import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  bool _showHint = false;
  int _currentHintIndex = 0;
  int _passwordStrength = 0;
  String _strengthFeedback = '';

  // Password hints
  final List<String> _hints = [
    'Try creating a password based on a memorable game character plus numbers and special characters.',
    'Combine your favorite game with your birthday, but replace some letters with symbols.',
    'Think of a power-up or in-game item and use it as the base for your password.',
    'Use the first letters of a gaming quote or catchphrase you love, then add numbers and symbols.'
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePasswordStrength);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;

    // Simple password strength calculation
    int strength = 0;
    String feedback = '';

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _strengthFeedback = '';
      });
      return;
    }

    // Check length
    if (password.length >= 8) {
      strength++;
    } else {
      feedback = 'Use at least 8 characters';
      setState(() {
        _passwordStrength = strength;
        _strengthFeedback = feedback;
      });
      return;
    }

    // Check for uppercase letters
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      strength++;
    } else {
      feedback = 'Add uppercase letters';
      setState(() {
        _passwordStrength = strength;
        _strengthFeedback = feedback;
      });
      return;
    }

    // Check for lowercase letters
    if (RegExp(r'[a-z]').hasMatch(password)) {
      strength++;
    } else {
      feedback = 'Add lowercase letters';
      setState(() {
        _passwordStrength = strength;
        _strengthFeedback = feedback;
      });
      return;
    }

    // Check for numbers
    if (RegExp(r'[0-9]').hasMatch(password)) {
      strength++;
    } else {
      feedback = 'Add numbers';
      setState(() {
        _passwordStrength = strength;
        _strengthFeedback = feedback;
      });
      return;
    }

    // Check for special characters
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      strength++;
    } else {
      feedback = 'Add special characters';
      setState(() {
        _passwordStrength = strength;
        _strengthFeedback = feedback;
      });
      return;
    }

    // Set feedback based on final strength
    if (strength <= 2) {
      feedback = 'Your password could be stronger';
    } else if (strength == 3) {
      feedback = 'Good password!';
    } else {
      feedback = 'Excellent password!';
    }

    setState(() {
      _passwordStrength = strength;
      _strengthFeedback = feedback;
    });
  }

  void _showNextHint() {
    setState(() {
      _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
    });
  }

  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isSubmitting = false;
      });

      // In a real app, you would navigate to the next screen
    }
  }

  void _skipReset() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Password reset skipped. You can reset it later from settings.'),
        backgroundColor: Colors.blue,
      ),
    );

    // In a real app, you would navigate to the next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset Your Password',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Create a new password to secure your gaming account',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter your new password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white60,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // if (_passwordController.text.isNotEmpty)
                      //   PasswordStrengthMeter(
                      //     strength: _passwordStrength,
                      //     feedback: _strengthFeedback,
                      //   ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your new password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white60,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords don\'t match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _resetPassword,
                        child: _isSubmitting
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Resetting...'),
                                ],
                              )
                            : const Text('Reset Password'),
                      ),
                      const SizedBox(height: 12.0),
                      OutlinedButton(
                        onPressed: _isSubmitting ? null : _skipReset,
                        child: const Text('Skip for Now'),
                      ),
                      const SizedBox(height: 24.0),
                      TextButton.icon(
                        icon: Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          _showHint ? 'Hide Hint' : 'Need a Hint?',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                        onPressed: _toggleHint,
                      ),
                      if (_showHint)
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password Challenge Hint',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (_hints.length > 1)
                                    TextButton(
                                      onPressed: _showNextHint,
                                      child: const Text('Next Hint'),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(_hints[_currentHintIndex]),
                            ],
                          ),
                        ),
                    ],
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
