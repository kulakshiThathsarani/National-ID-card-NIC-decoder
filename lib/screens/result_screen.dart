/// Screen to display the decoded information from a Sri Lankan NIC number.
///
/// This screen shows all extracted information from the NIC including:
/// - NIC format (old or new)
/// - Date of birth
/// - Weekday name
/// - Age
/// - Gender
/// - Voting eligibility (for old format only)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nic_controller.dart';

/// A screen widget that displays decoded NIC information.
///
/// This screen retrieves data from the [NicController] and presents it in
/// a user-friendly format with styled info cards for each data point.
class ResultScreen extends StatelessWidget {
  /// Creates a [ResultScreen] instance.
  ///
  /// The [key] parameter is optional and is passed to the parent class.
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Retrieve the existing NIC controller instance
    final controller = Get.find<NicController>();

    return Scaffold(
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80, bottom: 50),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF30A0A0), // Teal blue at top
                  Color(0xFF6E9ED7), // Lighter blue at bottom
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF001550), // Dark blue bottom border color
                  width: 8, // Thickness of the bottom border
                ),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Decoded NIC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10), // Added spacing
                Text(
                  'Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NIC Format
                          Obx(() => _buildInfoCard(
                                title: 'NIC Format',
                                value: Rx<String>(controller.isOldFormat.value
                                    ? 'Old Format (9-digit)'
                                    : 'New Format (12-digit)'),
                                icon: Icons.badge,
                              )),

                          const SizedBox(height: 16),

                          // Date of Birth
                          _buildInfoCard(
                            title: 'Date of Birth',
                            value: controller.dateOfBirth,
                            icon: Icons.calendar_today,
                          ),

                          const SizedBox(height: 16),

                          // Weekday Name
                          _buildInfoCard(
                            title: 'Weekday Name',
                            value: controller.weekdayName,
                            icon: Icons.date_range,
                          ),

                          const SizedBox(height: 16),

                          // Age
                          _buildInfoCard(
                            title: 'Age',
                            value: Rx<String>('${controller.age.value} Years'),
                            icon: Icons.people,
                          ),

                          const SizedBox(height: 16),

                          // Gender
                          _buildInfoCard(
                            title: 'Gender',
                            value: controller.gender,
                            icon: Icons.wc,
                          ),

                          const SizedBox(height: 16),

                          // Voting Eligibility (only for old format)
                          Obx(() => controller.isOldFormat.value
                              ? Column(
                                  children: [
                                    _buildInfoCard(
                                      title: 'Voting Eligibility',
                                      value: controller.canVote,
                                      icon: Icons.how_to_vote,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              : const SizedBox()),
                        ],
                      ),
                    ),
                  ),

                  // Button container with proper centering
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001550),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text(
                        'Decode Another NIC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navy blue footer with gradient
          Container(
            width: double.infinity,
            height: 20,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF5271FF), // Brighter blue on the left
                  Color(0xFF061552), // Navy blue on the right
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an info card widget to display a piece of decoded NIC information.
  ///
  /// This helper method creates a consistent card layout used for all information
  /// displayed on the results screen.
  ///
  /// [title] The label for this information (e.g., "Date of Birth").
  /// [value] The Rx value containing the actual information to display.
  /// [icon] The icon to show alongside this information.
  ///
  /// Returns a styled container widget with the formatted information.
  Widget _buildInfoCard({
    required String title,
    required Rx<dynamic> value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA), // Light blue background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF001550),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF001550),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      value.toString(),
                      style: TextStyle(
                        color: const Color(0xFF001550).withOpacity(0.7),
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
