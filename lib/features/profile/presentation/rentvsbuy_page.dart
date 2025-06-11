import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/features/profile/cubit/profile_cubit.dart';
import 'package:finder/features/profile/integation_backend.dart';
import 'package:finder/features/profile/rent_vs_buy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyVsRentCalculatorPage extends StatefulWidget {
  const BuyVsRentCalculatorPage({super.key});

  @override
  _BuyVsRentCalculatorPageState createState() =>
      _BuyVsRentCalculatorPageState();
}

class _BuyVsRentCalculatorPageState extends State<BuyVsRentCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'propertyPrice': TextEditingController(),
    'downPayment': TextEditingController(),
    'annualInterestRate': TextEditingController(),
    'loanTermYears': TextEditingController(),
    'monthlyRent': TextEditingController(),
    'yearsOfStay': TextEditingController(),
    'annualPropertyTax': TextEditingController(),
    'annualInsurance': TextEditingController(),
    'homeAppreciationRate': TextEditingController(),
    'rentIncreaseRate': TextEditingController(),
    'investmentReturnRate': TextEditingController(),
  };

  RentVsBuyModel? _resultModel; // Store the result model
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
          'Buy vs Rent Calculator',
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
              _buildSectionTitle('Property Details'),
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
              const SizedBox(height: 16),
              _buildSectionTitle('Rental Details'),
              _buildTextField(
                controller: _controllers['monthlyRent']!,
                labelText: 'Monthly Rent (\$)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['yearsOfStay']!,
                labelText: 'Years of Stay',
                keyboardType: TextInputType.number,
                validator: _validatePositiveInteger,
              ),
              _buildTextField(
                controller: _controllers['rentIncreaseRate']!,
                labelText: 'Rent Increase Rate (%)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Additional Costs & Rates'),
              _buildTextField(
                controller: _controllers['annualPropertyTax']!,
                labelText: 'Annual Property Tax (\$)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['annualInsurance']!,
                labelText: 'Annual Insurance (\$)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['homeAppreciationRate']!,
                labelText: 'Home Appreciation Rate (%)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              _buildTextField(
                controller: _controllers['investmentReturnRate']!,
                labelText: 'Investment Return Rate (%)',
                keyboardType: TextInputType.number,
                validator: _validatePositiveNumber,
              ),
              const SizedBox(height: 24),
              Center(
                child: CreateModel<RentVsBuyModel>(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: 'Calculate',
                          color: AppColors.primary,
                        ),
                  withValidation: true,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                      });
                      final newParams = RentVsBuyParams(
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
                        monthlyRent:
                            int.tryParse(_controllers['monthlyRent']!.text) ??
                                0,
                        yearsOfStay:
                            int.tryParse(_controllers['yearsOfStay']!.text) ??
                                0,
                        rentIncreaseRate: int.tryParse(
                                _controllers['rentIncreaseRate']!.text) ??
                            0,
                        annualPropertyTax: int.tryParse(
                                _controllers['annualPropertyTax']!.text) ??
                            0,
                        annualInsurance: int.tryParse(
                                _controllers['annualInsurance']!.text) ??
                            0,
                        homeAppreciationRate: int.tryParse(
                                _controllers['homeAppreciationRate']!.text) ??
                            0,
                        investmentReturnRate: int.tryParse(
                                _controllers['investmentReturnRate']!.text) ??
                            0,
                      );
                      context.read<ProfileCubit>().updateParams(newParams);
                      return true;
                    }
                    return false;
                  },
                  useCaseCallBack: (x) {
                    return RentVsBuyUseCase(
                      profileRepository: ProfileRepository(),
                    ).call(params: context.read<ProfileCubit>().params);
                  },
                  onSuccess: (RentVsBuyModel x) {
                    setState(() {
                      _resultModel = x; // Store the result model
                      _isLoading = false;
                    });
                  },
                ),
              ),
              if (_resultModel != null) ...[
                const SizedBox(height: 24),
                _buildResultCard(_resultModel!), // Display the result card
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

  Widget _buildResultCard(RentVsBuyModel x) {
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
            _buildResultRow('Total Cost of Buying',
                '\$${x.totalCostOfBuying?.toStringAsFixed(2) ?? '0.00'}'),
            _buildResultRow('Total Cost of Renting',
                '\$${x.totalCostOfRenting?.toStringAsFixed(2) ?? '0.00'}'),
            _buildResultRow('Equity Gained',
                '\$${x.equityGained?.toStringAsFixed(2) ?? '0.00'}'),
            _buildResultRow('Final Property Value',
                '\$${x.finalPropertyValue?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 8),
            Text(
              'Recommendation: ${x.suggestion ?? 'None'}',
              style: AppTextStyle.getBoldStyle(
                color: x.suggestion == 'Buy' ? Colors.green : Colors.blue,
                fontSize: AppFontSize.size_14,
              ),
            ),
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
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.getMediumStyle(
              color: Colors.black87,
              fontSize: 14,
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
