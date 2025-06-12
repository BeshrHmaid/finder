import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/features/profile/cubit/profile_cubit.dart';
import 'package:finder/features/profile/integation_backend.dart';
import 'package:finder/features/profile/monthly_payment.dart';
import 'package:finder/features/profile/morg_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MortgageCalculatorPage extends StatefulWidget {
  const MortgageCalculatorPage({super.key});

  @override
  _MortgageCalculatorPageState createState() => _MortgageCalculatorPageState();
}

class _MortgageCalculatorPageState extends State<MortgageCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'propertyPrice': TextEditingController(),
    'downPayment': TextEditingController(),
    'annualInterestRate': TextEditingController(),
    'loanTermYears': TextEditingController(),
  };

  MonthlyPayment? _resultModel; // Store the result model
  bool _isLoading = false;

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mortgage Calculator',
          style: AppTextStyle.getBoldStyle(
            color: Colors.white,
            fontSize: AppFontSize.size_18,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Mortgage Details'),
              _buildTextField(
                controller: _controllers['propertyPrice']!,
                labelText: 'Property Price (\$)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['downPayment']!,
                labelText: 'Down Payment (\$)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['annualInterestRate']!,
                labelText: 'Annual Interest Rate (%)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['loanTermYears']!,
                labelText: 'Loan Term (Years)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveInteger,
              ),
              const SizedBox(height: 24),
              Center(
                child: CreateModel<MonthlyPayment>(
                  child: CustomButton(
                    text: 'Calculate',
                    color: AppColors.primary,
                  ),
                  withValidation: true,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                      });
                      final newParams = MorgParams(
                        propertyPrice:
                            int.tryParse(_controllers['propertyPrice']!.text) ??
                                0,
                        downPayment:
                            int.tryParse(_controllers['downPayment']!.text) ??
                                0,
                        annualInterestRate: double.tryParse(
                                _controllers['annualInterestRate']!.text) ??
                            0,
                        loanTermYears:
                            int.tryParse(_controllers['loanTermYears']!.text) ??
                                0,
                      );
                      context.read<ProfileCubit>().updateMParams(newParams);
                      return true;
                    }
                    return false;
                  },
                  useCaseCallBack: (x) {
                    return MorgCalcUsecase(
                      profileRepository: ProfileRepository(),
                    ).call(params: context.read<ProfileCubit>().mParams);
                  },
                  onSuccess: (MonthlyPayment x) {
                    setState(() {
                      _resultModel = x;
                      _isLoading = false;
                    });
                  },
                ),
              ),
              if (_resultModel != null) ...[
                const SizedBox(height: 24),
                _buildResultCard(_resultModel!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTextStyle.getBoldStyle(
          color: AppColors.primary,
          fontSize: AppFontSize.size_16,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CustomTextFormField(
        controller: controller,
        labelText: labelText,
        keyboardType: keyboardType,
        borderColor: AppColors.primary,
        fillColor: Colors.grey[100],
        borderRadius: 12,
        validator: validator,
        textStyle: AppTextStyle.getRegularStyle(
          color: Colors.black87,
          fontSize: AppFontSize.size_14,
        ),
        hintStyle: AppTextStyle.getRegularStyle(
          color: Colors.grey,
          fontSize: AppFontSize.size_12,
        ),
      ),
    );
  }

  Widget _buildResultCard(MonthlyPayment x) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Results',
              style: AppTextStyle.getBoldStyle(
                color: AppColors.primary,
                fontSize: AppFontSize.size_16,
              ),
            ),
            const SizedBox(height: 12),
            _buildResultRow('Monthly Payment',
                '\$${x.monthlyPayment?.toStringAsFixed(2) ?? '0.00'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.getRegularStyle(
              color: Colors.black87,
              fontSize: AppFontSize.size_14,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.getMediumStyle(
              color: Colors.black87,
              fontSize: AppFontSize.size_14,
            ),
          ),
        ],
      ),
    );
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Enter a valid positive number';
    }
    return null;
  }

  String? _validatePositiveInteger(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Enter a valid positive integer';
    }
    return null;
  }
}
