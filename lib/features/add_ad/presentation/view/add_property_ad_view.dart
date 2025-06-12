import 'dart:io';

import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/dialogs/dialogs.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/features/add_ad/data/add_ad_repository.dart';
import 'package:finder/features/add_ad/data/usecase/add_ad_usecase.dart';
import 'package:finder/features/add_ad/presentation/cubit/add_property_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyAdScreen extends StatefulWidget {
  const AddPropertyAdScreen({Key? key}) : super(key: key);

  @override
  _AddPropertyAdScreenState createState() => _AddPropertyAdScreenState();
}

class _AddPropertyAdScreenState extends State<AddPropertyAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _propertyImages = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _propertyFor = 'Rent';
  int _bedrooms = 1;
  int _bathrooms = 1;
  final _areaController = TextEditingController();
  String _propertyType = 'Apartment';
  String _furnishing = 'Furnished';
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  int _currentStep = 0;

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
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  // Method to pick multiple images from gallery or single image from camera
  Future<void> _pickImage() async {
    if (_propertyImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 images allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (source != null) {
      if (source == ImageSource.gallery) {
        final List<XFile>? images = await picker.pickMultiImage();
        if (images != null && images.isNotEmpty) {
          setState(() {
            final newImages = images
                .map((xfile) => File(xfile.path))
                .take(5 - _propertyImages.length)
                .toList();
            _propertyImages.addAll(newImages);
          });
          // Update Cubit
          context.read<AddPropertyCubit>().updateAddParams(
                context.read<AddPropertyCubit>().params.copyWith(
                      pics: _propertyImages,
                    ),
              );
        }
      } else {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _propertyImages.add(File(image.path));
          });
          // Update Cubit
          context.read<AddPropertyCubit>().updateAddParams(
                context.read<AddPropertyCubit>().params.copyWith(
                      pics: _propertyImages,
                    ),
              );
        }
      }
    }
  }

  // Method to remove an image
  void _removeImage(int index) {
    setState(() {
      _propertyImages.removeAt(index);
    });
    // Update Cubit
    context.read<AddPropertyCubit>().updateAddParams(
          context.read<AddPropertyCubit>().params.copyWith(
                pics: _propertyImages,
              ),
        );
  }

  // Method to submit the form
  // void _submitForm() async {
  //   // a
  //   if (_formKey.currentState!.validate()) {
  //     // Update Cubit with all form data
  //     context.read<AddPropertyCubit>().updateAddParams(
  //           context.read<AddPropertyCubit>().params.copyWith(
  //                 title: _titleController.text,
  //                 description: _descriptionController.text,
  //                 price: double.tryParse(_priceController.text),
  //                 location:
  //                     '${_addressController.text}, ${_cityController.text}',
  //                 pics: _propertyImages,
  //                 listingType: _propertyFor.toLowerCase(),
  //                 // bedrooms: _bedrooms,
  //                 // bathrooms: _bathrooms,
  //                 // area: double.tryParse(_areaController.text),
  //                 // propertyType: _propertyType,
  //                 // furnishing: _furnishing,
  //               ),
  //         );
  //     final x = await AddAdUsecase(addAdRepository: AddAdRepository())
  //         .call(params: context.read<AddPropertyCubit>().params);
  //     if (x.hasDataOnly) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text('Property ad submitted successfully!'),
  //           backgroundColor: AppColors.primary,
  //         ),
  //       );
  //       // Navigate back or to another screen
  //       Navigator.pop(context);
  //     } else if (x.hasErrorOnly) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Something went wrong, please try again later'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //     // Clear the form
  //     setState(() {
  //       _propertyImages.clear();
  //       _titleController.clear();
  //       _descriptionController.clear();
  //       _priceController.clear();
  //       _propertyFor = 'Rent';
  //       _bedrooms = 1;
  //       _bathrooms = 1;
  //       _areaController.clear();
  //       _propertyType = 'Apartment';
  //       _furnishing = 'Furnished';
  //       _addressController.clear();
  //       _cityController.clear();
  //       _zipCodeController.clear();
  //       _currentStep = 0;
  //     });
  //     // Clear Cubit pics
  //     context.read<AddPropertyCubit>().updateAddParams(
  //           context.read<AddPropertyCubit>().params.copyWith(
  //             pics: [],
  //           ),
  //         );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property Ad'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppFontSize.size_12,
          vertical: AppFontSize.size_12,
        ),
        child: Column(
          children: [
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
                    // _submitForm();
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
                        (_currentStep == 4)
                            ? SizedBox(
                                width: 120,
                                child: CreateModel(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      return true;
                                    } else {
                                      Dialogs.showErrorSnackBar(
                                        message:
                                            'Please fill all the required information ',
                                        context: context,
                                      );
                                      return false;
                                    }
                                  },
                                  useCaseCallBack: (x) {
                                    context
                                        .read<AddPropertyCubit>()
                                        .updateAddParams(
                                          context
                                              .read<AddPropertyCubit>()
                                              .params
                                              .copyWith(
                                                title: _titleController.text,
                                                description:
                                                    _descriptionController.text,
                                                price: double.tryParse(
                                                    _priceController.text),
                                                location:
                                                    '${_addressController.text}, ${_cityController.text}',
                                                pics: _propertyImages,
                                                listingType:
                                                    _propertyFor.toLowerCase(),
                                                // bedrooms: _bedrooms,
                                                // bathrooms: _bathrooms,
                                                // area: double.tryParse(_areaController.text),
                                                // propertyType: _propertyType,
                                                // furnishing: _furnishing,
                                              ),
                                        );
                                    return AddAdUsecase(
                                            addAdRepository: AddAdRepository())
                                        .call(
                                            params: context
                                                .read<AddPropertyCubit>()
                                                .params);
                                  },
                                  onSuccess: (x) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Property ad submitted successfully!'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                    setState(() {
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
                                      _currentStep = 0;
                                    });
                                    // Clear Cubit pics
                                    context
                                        .read<AddPropertyCubit>()
                                        .updateAddParams(
                                          context
                                              .read<AddPropertyCubit>()
                                              .params
                                              .copyWith(
                                            pics: [],
                                          ),
                                        );
                                    // Navigator.pop(context);
                                  },
                                  child: CustomButton(
                                    text: 'Submit',
                                    color: AppColors.primary,
                                  ),
                                  withValidation: true,
                                ),
                              )
                            : Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(fontSize: 16),
                              ),
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
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
                                    onPressed: _pickImage,
                                    icon: Icon(
                                      Icons.add_photo_alternate,
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                    label: Text(
                                      'Add Images',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                          onTap: _pickImage,
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey[400]!),
                                            ),
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              color: AppColors.primary,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: FileImage(
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
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 20,
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
                            color: _propertyImages.length >= 5
                                ? Colors.red
                                : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  // Step 2: Basic Details
                  Step(
                    stepStyle: StepStyle(color: AppColors.primary),
                    title: const Text('Basic Details'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
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
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Describe your property...',
                            prefixIcon: Icon(Icons.description,
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
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'This property is for:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
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
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return AppColors.primary;
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Colors.white;
                                      }
                                      return Colors.black87;
                                    },
                                  ),
                                  side: WidgetStateProperty.all(
                                    BorderSide(color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  // Step 3: Property Features
                  Step(
                    stepStyle: StepStyle(color: AppColors.primary),
                    title: const Text('Property Features'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        TextFormField(
                          controller: _areaController,
                          decoration: InputDecoration(
                            labelText: 'Area (sq ft)',
                            hintText: 'Enter property area',
                            prefixIcon: Icon(Icons.square_foot,
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
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
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
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
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
                    state: _currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  // Step 4: Location & Contact
                  Step(
                    stepStyle: StepStyle(color: AppColors.primary),
                    title: const Text('Location & Contact'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        TextFormField(
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
                      ],
                    ),
                    isActive: _currentStep >= 3,
                    state: _currentStep > 3
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  // Step 5: Ad Settings
                  Step(
                    stepStyle: StepStyle(color: AppColors.primary),
                    title: const Text('Ad Settings'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                    state: _currentStep > 4
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                ],
              ),
            ),
          ],
        ),
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
