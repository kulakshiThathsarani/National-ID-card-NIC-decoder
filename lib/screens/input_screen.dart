/// Screen for inputting a Sri Lankan National Identity Card (NIC) number.
///
/// This screen provides a user interface for entering either the old format (9-digit + v/x)
/// or new format (12-digit) NIC numbers. It includes validation and a button to decode
/// the entered NIC number.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nic_controller.dart';
import 'result_screen.dart';

/// A screen widget that provides a UI for inputting NIC numbers.
///
/// This screen contains:
/// - A header with the application title
/// - An input field for entering the NIC number
/// - A decode button that becomes active when a valid NIC format is entered
/// - Information about supported NIC formats
class InputScreen extends StatelessWidget {
  /// Creates an [InputScreen] instance.
  ///
  /// The [key] parameter is optional and is passed to the parent class.
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Initialize and inject the NIC controller
    final controller = Get.put(NicController());

    return Scaffold(
      body: Column(
        children: [
          // Gradient Header with dark blue bottom border
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF30A0A0), // Teal/turquoise at top
                  Color(0xFF6E9ED7), // Light blue/purple at bottom
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xFF001550), // Dark blue bottom border
                  width: 8, // Thickness of the border
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF001550), // Dark blue border color
                  offset: Offset(0, 1), // Move shadow down
                  spreadRadius: -1,
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'NIC Decoder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Card container with increased size
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001550), // Dark blue card
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32), // Increased padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title with gradient color
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(
                                    0xFF00F5A0), // Light greenish color on the left
                                Color(
                                    0xFF00D9F5), // Light cyan color on the right
                              ],
                            ).createShader(Rect.fromLTWH(
                                0, 0, bounds.width, bounds.height));
                          },
                          child: const Text(
                            'Enter Your Sri Lankan NIC',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32), // Increased gap

                        // Input field with rounded corners and search icon
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            onChanged: controller.setNicNumber,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText:
                                  'Enter NIC (eg: 761421789v or 198515664391)',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32), // Increased gap

                        // Decode button - teal color with rounded corners
                        Obx(() => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF00F5A0), // Light greenish color
                                    Color(0xFF00D9F5), // Light cyan color
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                onPressed: controller.isValid.value
                                    ? () {
                                        controller.decodeNic();
                                        Get.to(() => const ResultScreen());
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  minimumSize: const Size(170, 50),
                                ),
                                child: const Text(
                                  'DECODE NIC',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )),

                        const SizedBox(height: 32), // Increased gap

                        // Footer text - smaller size with reduced opacity
                        const Text(
                          'Supports both 9-digit and 12-digit NIC formats.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Your data is secure.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
}
