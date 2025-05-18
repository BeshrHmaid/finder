import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/features/home/presentation/widget/home_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddPropertyAdScreen extends StatefulWidget {
  const AddPropertyAdScreen({Key? key}) : super(key: key);

  @override
  _AddPropertyAdScreenState createState() => _AddPropertyAdScreenState();
}

class _AddPropertyAdScreenState extends State<AddPropertyAdScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Property images
  final List<String> _propertyImages = [];

  // Basic details
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _propertyFor = 'Rent';

  // Property features
  int _bedrooms = 1;
  int _bathrooms = 1;
  final _areaController = TextEditingController();
  String _propertyType = 'Apartment';
  String _furnishing = 'Furnished';

  // Location
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  // Contact information
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Ad settings
  DateTime _availabilityDate = DateTime.now().add(const Duration(days: 1));
  bool _highlightAd = false;

  // Current active step in the stepper
  int _currentStep = 0;

  // Lists for dropdowns
  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Studio',
    'Villa',
    'Penthouse',
    'Townhouse',
    'Farmhouse',
    'Land'
  ];

  final List<String> _furnishingTypes = [
    'Furnished',
    'Semi-Furnished',
    'Unfurnished'
  ];

  @override
  void dispose() {
    // Dispose all controllers
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Method to add an image
  void _addImage(String imageUrl) {
    if (_propertyImages.length < 5) {
      setState(() {
        _propertyImages.add(imageUrl);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed')),
      );
    }
  }

  // Method to remove an image
  void _removeImage(int index) {
    setState(() {
      _propertyImages.removeAt(index);
    });
  }

  // Method to select availability date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _availabilityDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _availabilityDate) {
      setState(() {
        _availabilityDate = picked;
      });
    }
  }

  // Method to submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would save the data to a database or API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Property ad submitted successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );

      // Clear the form
      _propertyImages.clear();
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _propertyFor = 'Rent';
      _bedrooms = 1;
      _bathrooms = 1;
      _areaController.clear();
      _propertyType = 'Apartment';
      _furnishing = 'Furnished';
      _addressController.clear();
      _cityController.clear();
      _zipCodeController.clear();
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _availabilityDate = DateTime.now().add(const Duration(days: 1));
      _highlightAd = false;

      // Reset stepper
      setState(() {
        _currentStep = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   backgroundColor: Colors.white,
        //   appBar: AppBar(
        //     title:  Text(
        //       "Add Property Ad",
        //       style: TextStyle(color: AppColors.primary),
        //     ),
        //     backgroundColor: Colors.white,
        //     elevation: 0,
        //     iconTheme:  IconThemeData(color: AppColors.primary),
        //   ),
        // body:
        SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppFontSize.size_12, vertical: AppFontSize.size_12),
      child: Column(
        children: [
          const HomeViewHeader(
            isPredictPage: true,
            headerTitle: 'Add Property Ad',
          ),
          Form(
            key: _formKey,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 4) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  _submitForm();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _currentStep == 4 ? 'Submit' : 'Continue',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (_currentStep > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Back',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                    ],
                  ),
                );
              },
              steps: [
                // Step 1: Property Images
                Step(
                  stepStyle: StepStyle(color: AppColors.primary),
                  title: const Text('Property Images'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload up to 5 images of your property',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _propertyImages.isEmpty
                            ? Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // For demo, we'll just add a placeholder image
                                    _addImage(
                                        'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=');
                                  },
                                  icon: Icon(Icons.add_photo_alternate,
                                      color: AppColors.primary),
                                  label: Text(
                                    'Add Images',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(8),
                                itemCount: _propertyImages.length < 5
                                    ? _propertyImages.length + 1
                                    : _propertyImages.length,
                                itemBuilder: (context, index) {
                                  if (index == _propertyImages.length &&
                                      _propertyImages.length < 5) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          _addImage(
                                              'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=');
                                        },
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey[400]!),
                                          ),
                                          child: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.grey,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  _propertyImages[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: InkWell(
                                            onTap: () => _removeImage(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_propertyImages.length}/5 images uploaded',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),

                // Step 2: Basic Details
                Step(
                  stepStyle: StepStyle(color: AppColors.primary),
                  title: const Text('Basic Details'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'e.g., 3BHK Apartment in Downtown',
                          prefixIcon:
                              Icon(Icons.title, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Describe your property...',
                          prefixIcon:
                              Icon(Icons.description, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Price
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: 'Enter price',
                          prefixIcon: Icon(Icons.attach_money,
                              color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Property For (Rent/Buy)
                      Row(
                        children: [
                          const Text('This property is for:'),
                          const SizedBox(width: 16),
                          Expanded(
                            // flex: 3,
                            child: SegmentedButton<String>(
                              showSelectedIcon: false,
                              segments: const [
                                ButtonSegment<String>(
                                  value: 'Rent',
                                  label: Text('Rent'),
                                ),
                                ButtonSegment<String>(
                                  value: 'Buy',
                                  label: Text('Buy'),
                                ),
                              ],
                              selected: {_propertyFor},
                              onSelectionChanged: (Set<String> selection) {
                                setState(() {
                                  _propertyFor = selection.first;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColors.primary;
                                    }
                                    return Colors.white;
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.white;
                                    }
                                    return Colors.black87;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),

                // Step 3: Property Features
                Step(
                  stepStyle: StepStyle(color: AppColors.primary),
                  title: const Text('Property Features'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bedrooms and Bathrooms
                      Row(
                        children: [
                          Expanded(
                            child: _buildCounterField(
                              'Bedrooms',
                              _bedrooms,
                              (value) {
                                setState(() {
                                  _bedrooms = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCounterField(
                              'Bathrooms',
                              _bathrooms,
                              (value) {
                                setState(() {
                                  _bathrooms = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Area
                      TextFormField(
                        controller: _areaController,
                        decoration: InputDecoration(
                          labelText: 'Area (sq ft)',
                          hintText: 'Enter property area',
                          prefixIcon:
                              Icon(Icons.square_foot, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter property area';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Property Type
                      DropdownButtonFormField<String>(
                        value: _propertyType,
                        decoration: InputDecoration(
                          labelText: 'Property Type',
                          prefixIcon:
                              Icon(Icons.home_work, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        items: _propertyTypes
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _propertyType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Furnishing
                      DropdownButtonFormField<String>(
                        value: _furnishing,
                        decoration: InputDecoration(
                          labelText: 'Furnishing',
                          prefixIcon:
                              Icon(Icons.chair, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        items: _furnishingTypes
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _furnishing = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                  state:
                      _currentStep > 2 ? StepState.complete : StepState.indexed,
                ),

                // Step 4: Location & Contact
                Step(
                  stepStyle: StepStyle(color: AppColors.primary),
                  title: const Text('Location & Contact'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            hintText: 'Enter property address',
                            prefixIcon: Icon(Icons.location_on,
                                color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // City and Zip Code
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  prefixIcon: Icon(Icons.location_city,
                                      color: AppColors.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a city';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _zipCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Zip Code',
                                  prefixIcon:
                                      Icon(Icons.pin, color: AppColors.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter zip code';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon:
                                Icon(Icons.person, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon:
                                Icon(Icons.phone, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon:
                                Icon(Icons.email, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  isActive: _currentStep >= 3,
                  state:
                      _currentStep > 3 ? StepState.complete : StepState.indexed,
                ),

                // Step 5: Ad Settings
                Step(
                  stepStyle: StepStyle(color: AppColors.primary),
                  title: const Text('Ad Settings'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Availability Date
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Availability Date',
                            prefixIcon: Icon(Icons.calendar_today,
                                color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(_availabilityDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Highlight Ad
                      SwitchListTile(
                        title: const Text('Highlight Ad'),
                        subtitle: const Text(
                            'Make your ad stand out in search results'),
                        value: _highlightAd,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _highlightAd = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Terms and Conditions
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            activeColor: AppColors.primary,
                            onChanged: (value) {},
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to the terms and conditions',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 4,
                  state:
                      _currentStep > 4 ? StepState.complete : StepState.indexed,
                ),
              ],
            ),
            // ),
          ),
        ],
      ),
    );
  }

  // Helper method to build counter fields
  Widget _buildCounterField(
      String label, int value, ValueChanged<int> onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: value > 1 ? AppColors.primary : Colors.grey,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: value < 10 ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add_circle_outline),
                color: value < 10 ? AppColors.primary : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
