import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:finder/features/home/presentation/widget/home_page_header.dart';
import 'package:finder/features/price_predication/prediction_model/prediction_model.dart';
import 'package:finder/features/price_predication/presentation/backend_integration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PredictHousePricePage extends StatefulWidget {
  const PredictHousePricePage({Key? key}) : super(key: key);

  @override
  _PredictHousePricePageState createState() => _PredictHousePricePageState();
}

class _PredictHousePricePageState extends State<PredictHousePricePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final _sizeController = TextEditingController();
  final _roomsController = TextEditingController();
  final _propertyAgeController = TextEditingController();

  // Dropdown values
  String? _priceCategory;
  String? _type;
  String? _furnishing;
  String? _completionStatus;
  String? _city;
  String? _community;

  // State variables
  bool _isLoading = false;
  bool _showPrediction = false;
  PredictionModel? _predictionResult;

  // City and Community options
  final List<String> _cities = [
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Ajman',
    'Ras Al Khaimah',
  ];

  final Map<String, List<String>> _communitiesByCity = {
    'Dubai': [
      'Jumeirah Village Circle (JVC)',
      'Motor City',
      'Mudon',
      'Dubai Creek Harbour',
      'The Springs',
      'Dubai South (Residential District)',
      'DAMAC Hills (Akoya by DAMAC)',
      'Sobha Hartland',
      'Business Bay',
      'Dubai Marina',
      'Mohammed Bin Rashid City',
      'Reem',
      'Culture Village',
      'Dubai Sports City',
      'Dubai Residence Complex',
      'Jumeirah Lake Towers (JLT)',
      'Arjan',
      'Green Community',
      'Uptown Motor City',
      'East Village',
      'The World Islands',
      'Al Furjan',
    ],
    'Abu Dhabi': [
      'Yas Island',
      'Zayed City',
      'Saadiyat Island',
      'Al Reem Island',
      'Khalifa City',
      'Al Raha Gardens',
      'Al Raha Beach',
      'Saadiyat Lagoons',
      'Mina Al Arab',
    ],
    'Sharjah': [
      'Tilal City',
      'Al Rahmaniya',
      'Aljada',
      'Sharjah Garden City',
      'Muwaileh',
      'Shaghrafa 1',
      'Al Yash',
    ],
    'Ajman': [
      'Al Rashidiya',
      'Garden City',
      'Al Sawan',
      'Al Helio',
      'Al Yasmeen',
    ],
    'Ras Al Khaimah': [
      'Mina Al Arab',
    ],
  };

  @override
  void dispose() {
    _sizeController.dispose();
    _roomsController.dispose();
    _propertyAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppFontSize.size_12, vertical: AppFontSize.size_12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HomeViewHeader(
                    headerTitle: 'Predict your house price',
                    isPredictPage: true,
                  ),
                  const SizedBox(height: AppPaddingSize.padding_14),
                  _buildSectionTitle('Property Details'),
                  const SizedBox(height: 16),

                  // Price Category Dropdown
                  _buildDropdown(
                    label: 'Price Category',
                    value: _priceCategory,
                    items: ['High', 'Medium', 'Low'],
                    onChanged: (value) {
                      setState(() {
                        _priceCategory = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a price category' : null,
                  ),
                  const SizedBox(height: 16),

                  // Type Dropdown
                  _buildDropdown(
                    label: 'Property Type',
                    value: _type,
                    items: ['Apartment', 'Villa', 'Townhouse'],
                    onChanged: (value) {
                      setState(() {
                        _type = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a property type' : null,
                  ),
                  const SizedBox(height: 16),

                  // Furnishing Dropdown
                  _buildDropdown(
                    label: 'Furnishing',
                    value: _furnishing,
                    items: ['Furnished', 'Unfurnished', 'Partially Furnished'],
                    onChanged: (value) {
                      setState(() {
                        _furnishing = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Please select furnishing status'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Completion Status Dropdown
                  _buildDropdown(
                    label: 'Completion Status',
                    value: _completionStatus,
                    items: ['Ready', 'Off-Plan'],
                    onChanged: (value) {
                      setState(() {
                        _completionStatus = value;
                      });
                    },
                    validator: (value) => value == null
                        ? 'Please select completion status'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // City Dropdown
                  _buildDropdown(
                    label: 'City',
                    value: _city,
                    items: _cities,
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                        _community = null; // Reset community when city changes
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a city' : null,
                  ),
                  const SizedBox(height: 16),

                  // Community Dropdown
                  _buildDropdown(
                    label: 'Community',
                    value: _community,
                    items: _city != null ? _communitiesByCity[_city] ?? [] : [],
                    onChanged: (value) {
                      setState(() {
                        _community = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a community' : null,
                  ),
                  const SizedBox(height: 16),

                  // Size
                  _buildTextField(
                    controller: _sizeController,
                    label: 'Size (sqft)',
                    hint: 'Enter property size',
                    icon: Icons.square_foot,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the size';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Total Rooms
                  _buildTextField(
                    controller: _roomsController,
                    label: 'Total Rooms',
                    hint: 'Enter number of rooms',
                    icon: Icons.bedroom_parent,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of rooms';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Property Age
                  _buildTextField(
                    controller: _propertyAgeController,
                    label: 'Property Age',
                    hint: 'Enter property age in years',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter property age';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Please enter a valid number';
                      }
                      if (age < 0) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Predict Button
                  CreateModel(
                    withValidation: true,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<HomeCubit>().updateParams(
                              priceCategory: _priceCategory,
                              type: _type,
                              furnishing: _furnishing,
                              completionStatus: _completionStatus,
                              community: _community,
                              city: _city,
                              sizeSqft: int.parse(_sizeController.text),
                              totalRooms: int.parse(_roomsController.text),
                              propertyAge:
                                  int.parse(_propertyAgeController.text),
                            );
                        return true;
                      }
                      return false;
                    },
                    useCaseCallBack: (x) {
                      return PredictHouseUsecase(
                              predictionRepository: PredictionRepository())
                          .call(params: context.read<HomeCubit>().params);
                    },
                    onSuccess: (PredictionModel x) {
                      setState(() {
                        _showPrediction = true;
                        _predictionResult = x;
                      });
                    },
                    child: const CustomButton(text: 'Predict Price'),
                  ),
                  const SizedBox(height: 32),

                  // Prediction Display
                  if (_showPrediction && _predictionResult != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Estimated Price',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'AED ${_predictionResult!.predictedPriceAed!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'This estimate is based on current market trends and the details you provided.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
