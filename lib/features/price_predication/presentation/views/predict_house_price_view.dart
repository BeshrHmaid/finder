import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/features/home/presentation/widget/home_page_header.dart';
import 'package:flutter/material.dart';

class PredictHousePricePage extends StatefulWidget {
  const PredictHousePricePage({Key? key}) : super(key: key);

  @override
  _PredictHousePricePageState createState() => _PredictHousePricePageState();
}

class _PredictHousePricePageState extends State<PredictHousePricePage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final _locationController = TextEditingController();
  final _roomsController = TextEditingController();
  final _sizeController = TextEditingController();
  final _yearBuiltController = TextEditingController();
  final _decorStyleController = TextEditingController();
  final _bathroomsController = TextEditingController();

  // State variables
  bool _hasParking = false;
  double _amenitiesScore = 5.0;
  bool _isLoading = false;
  bool _showPrediction = false;
  double _predictedPrice = 0.0;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _locationController.dispose();
    _roomsController.dispose();
    _sizeController.dispose();
    _yearBuiltController.dispose();
    _decorStyleController.dispose();
    _bathroomsController.dispose();
    super.dispose();
  }

  // Method to predict house price
  void _predictPrice() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call for price prediction
      Future.delayed(const Duration(seconds: 2), () {
        // In a real app, this would be an API call to a ML model
        // For now, we'll use a simple formula for demonstration
        final rooms = int.tryParse(_roomsController.text) ?? 0;
        final size = double.tryParse(_sizeController.text) ?? 0;
        final yearBuilt = int.tryParse(_yearBuiltController.text) ?? 2000;
        final bathrooms = double.tryParse(_bathroomsController.text) ?? 0;

        // Simple formula (would be replaced by actual AI model)
        final basePrice = size * 200;
        final ageAdjustment = (2025 - yearBuilt) * 500;
        final roomsValue = rooms * 15000;
        final bathroomsValue = bathrooms * 10000;
        final parkingValue = _hasParking ? 20000 : 0;
        final amenitiesValue = _amenitiesScore * 5000;

        _predictedPrice = basePrice +
            roomsValue +
            bathroomsValue +
            parkingValue +
            amenitiesValue -
            ageAdjustment;

        setState(() {
          _isLoading = false;
          _showPrediction = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        //Scaffold(
        // backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title:  Text(
        //     "Predict House Price",
        //     style: TextStyle(color: AppColors.primary),
        //   ),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   iconTheme:  IconThemeData(color: AppColors.primary),
        // ),
        // body:
        SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppFontSize.size_12, vertical: AppFontSize.size_12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeViewHeader(
                isPredictPage: true,
              ),
              const SizedBox(
                height: AppPaddingSize.padding_14,
              ),
              _buildSectionTitle('Property Details'),
              const SizedBox(height: 16),

              // Location
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Enter property location',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // House Size
              _buildTextField(
                controller: _sizeController,
                label: 'House Size (sqft)',
                hint: 'Enter property size',
                icon: Icons.square_foot,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the house size';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Year Built
              _buildTextField(
                controller: _yearBuiltController,
                label: 'Year Built',
                hint: 'Enter year built',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year built';
                  }
                  final year = int.tryParse(value);
                  if (year == null) {
                    return 'Please enter a valid year';
                  }
                  if (year < 1800 || year > 2025) {
                    return 'Please enter a year between 1800 and 2025';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Interior Details'),
              const SizedBox(height: 16),

              // Number of Rooms
              _buildTextField(
                controller: _roomsController,
                label: 'Number of Rooms',
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

              // Number of Bathrooms
              _buildTextField(
                controller: _bathroomsController,
                label: 'Number of Bathrooms',
                hint: 'Enter number of bathrooms',
                icon: Icons.bathroom,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of bathrooms';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Decor Style
              _buildTextField(
                controller: _decorStyleController,
                label: 'Decor Style / Interior Condition',
                hint: 'E.g., Modern, Traditional, Renovated',
                icon: Icons.style,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Additional Features'),
              const SizedBox(height: 16),

              // Parking Available
              _buildSwitchTile(
                title: 'Parking Available',
                value: _hasParking,
                onChanged: (value) {
                  setState(() {
                    _hasParking = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Nearby Amenities Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nearby Amenities Score: ${_amenitiesScore.toInt()}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: AppColors.primary,
                      valueIndicatorColor: AppColors.primary,
                      showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: Slider(
                      min: 1,
                      max: 10,
                      divisions: 9,
                      value: _amenitiesScore,
                      label: _amenitiesScore.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          _amenitiesScore = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    '1 = Few amenities nearby, 10 = Many amenities nearby',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Predict Button
              ElevatedButton(
                onPressed: _isLoading ? null : _predictPrice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Predict Price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 32),

              // Prediction Display
              if (_showPrediction)
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
                        '\$${_predictedPrice.toStringAsFixed(2)}',
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
      // ),
    );
  }

  // Helper method to build text fields
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

  // Helper method to build section titles
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

  // Helper method to build switch tiles
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}
