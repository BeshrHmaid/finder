import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/action_alert_dialog.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/features/root_navigation_view/data/cubit/root_page_cubit.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Sample user data - in a real app this would come from a database or API
  // final String userName = "John Doe";
  // final String userEmail = "john.doe@example.com";
  // final String userPhone = "+1 (555) 123-4567";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with user image
            Container(
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  )),
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    // ClipOval(
                    //   child: CachedNetworkImage(
                    //     imageUrl: AppStrings.dummyProfileImageUrl,
                    //     width: 100,
                    //     height: 100,
                    //     fit: BoxFit.cover,
                    //     placeholder: (context, url) => Container(
                    //       width: 100,
                    //       height: 100,
                    //       color: Colors.grey[300],
                    //       child:
                    //           const Center(child: CupertinoActivityIndicator()),
                    //     ),
                    //     errorWidget: (context, url, error) => Container(
                    //       width: 100,
                    //       height: 100,
                    //       color: Colors.grey,
                    //       child: const Icon(Icons.error, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    Text(
                      CacheHelper.userInfo?.username ?? 'No name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   userEmail,
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              // Edit profile functionality
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content:
                              //           Text('Edit Profile button pressed')),
                              // );
                              GoRouter.of(context)
                                  .push(AppRouter.kEditProfileView);
                            },
                            text: '',
                            color: AppColors.white,
                            rowChild: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color: AppColors.primary),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Edit Profile',
                                  style: AppTextStyle.getMediumStyle(
                                      color: AppColors.primary,
                                      fontSize: AppFontSize.size_16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Personal Information Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Information Cards
            _buildInfoCard(Icons.person, 'Full Name',
                CacheHelper.userInfo?.username ?? ''),
            // _buildInfoCard(Icons.email, 'Email', userEmail),
            _buildInfoCard(
                Icons.phone, 'Phone', CacheHelper.userInfo?.phoneNumber ?? ''),
            // _buildInfoCard(Icons.location_on, 'Location', 'New York, USA'),

            // Preferences Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                GoRouter.of(context).push(
                    AppRouter.kMortgageCalculator); // Adjust route as needed
              },
              child: _buildActionCard(
                'Mortgage Calculator',
                'Calculate your monthly mortgage payments based on property price, down payment, interest rate, and loan term',
                true,
                (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mortgage Notifications: $value')),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                GoRouter.of(context).push(AppRouter.kRentvsBuy);
              },
              child: _buildActionCard(
                'Rent Vs Buy',
                'evaluate the financial implications of choosing between renting and buying a house',
                true,
                (value) {
                  // Handle toggle
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Property Notifications: $value')),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Finder App Specific Preferences
            _buildPreferenceCard(
              'Property Notifications',
              'Get notified about new properties matching your criteria',
              true,
              (value) {
                // Handle toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Property Notifications: $value')),
                );
              },
            ),

            _buildPreferenceCard(
              'Price Predictions',
              'Enable AI price predictions for properties',
              true,
              (value) {
                // Handle toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Price Predictions: $value')),
                );
              },
            ),

            _buildPreferenceCard(
              'Show Similar Properties',
              'See properties similar to ones you\'ve viewed',
              false,
              (value) {
                // Handle toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Show Similar Properties: $value')),
                );
              },
            ),

            // Account Actions
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                onPressed: () {
                  // Logout functionality
                  ActionAlertDialog.show(context,
                      dialogTitle: AppLocalizations.of(context)!.confirmLogout,
                      confirmText: AppLocalizations.of(context)!.logout,
                      cancelText: AppLocalizations.of(context)!.cancel,
                      onConfirm: () {
                    Navigator.pop(context);
                    CacheHelper.deleteCertificates();
                    context.read<RootPageCubit>().changePageIndex(0);
                    GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                  });
                },
                color: AppColors.primary,
                text: 'Logout',
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build information cards
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  // Helper method to build preference toggle cards
  Widget _buildPreferenceCard(String title, String subtitle, bool initialValue,
      Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: initialValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, bool initialValue,
      Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
