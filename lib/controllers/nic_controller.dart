/// Controller that handles the Sri Lankan NIC decoding logic.
///
/// This controller processes both old format (9-digit + v/x) and new format
/// (12-digit) Sri Lankan National Identity Card numbers to extract information
/// such as:
/// - Date of birth
/// - Weekday name
/// - Age
/// - Gender
/// - Voting eligibility (for old format only)
///
/// The controller follows a reactive programming pattern using GetX,
/// with observable values that automatically update the UI when changed.
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Controller class for NIC decoding functionality.
///
/// This controller:
/// 1. Validates NIC format (old vs new)
/// 2. Extracts birth year, day of year, and gender information
/// 3. Calculates age based on current date
/// 4. Determines voting eligibility (for old format)
/// 5. Formats date information for display
class NicController extends GetxController {
  /// The entered NIC number.
  ///
  /// This reactive variable stores the raw input from the user.
  final nicNumber = ''.obs;

  /// The decoded date of birth in YYYY/MM/DD format.
  ///
  /// Extracted from the NIC number and formatted for readability.
  final dateOfBirth = ''.obs;

  /// The weekday name of the birth date (e.g., "Monday", "Tuesday").
  ///
  /// Calculated based on the extracted date of birth.
  final weekdayName = ''.obs;

  /// The calculated age in years.
  ///
  /// Computed as the difference between the current date and birth date,
  /// accounting for month and day to ensure accuracy.
  final age = 0.obs;

  /// The gender derived from the NIC number.
  ///
  /// Set to "Male" if day value < 500, otherwise "Female".
  final gender = ''.obs;

  /// Voting eligibility information.
  ///
  /// For old format: "Yes" (if 'v') or "No" (if 'x').
  /// For new format: "Not specified in new format".
  final canVote = ''.obs;

  /// Whether the entered NIC number is in a valid format.
  ///
  /// Used to enable/disable the decode button.
  final isValid = false.obs;

  /// Indicates if the NIC is in old format (true) or new format (false).
  ///
  /// Old format: 9 digits + 'v' or 'x'
  /// New format: 12 digits
  final isOldFormat = false.obs;

  /// Sets the NIC number and validates its format.
  ///
  /// This method is called whenever the user types in the input field.
  /// It trims the input and then calls the [validate] method.
  ///
  /// [value] The NIC number string input by the user.
  void setNicNumber(String value) {
    nicNumber.value = value.trim();
    validate();
  }

  /// Validates if the entered NIC is in the correct format.
  ///
  /// Checks against regular expressions for both old and new formats:
  /// - Old format: 9 digits followed by 'v' or 'x'
  /// - New format: 12 digits
  ///
  /// Updates [isValid] and [isOldFormat] based on the validation result.
  void validate() {
    final nic = nicNumber.value.toLowerCase();

    // Check if old format (9 digits + 'v' or 'x')
    if (RegExp(r'^\d{9}[vx]$').hasMatch(nic)) {
      isOldFormat.value = true;
      isValid.value = true;
    }
    // Check if new format (12 digits)
    else if (RegExp(r'^\d{12}$').hasMatch(nic)) {
      isOldFormat.value = false;
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }

  /// Decodes the NIC number to extract all information.
  ///
  /// This method:
  /// 1. Extracts the birth year and day of year from the NIC
  /// 2. Determines gender based on the day value
  /// 3. Calculates the actual date of birth
  /// 4. Computes age based on current date
  /// 5. Sets voting eligibility (for old format)
  ///
  /// All reactive variables are updated with the decoded information.
  void decodeNic() {
    if (!isValid.value) return;

    final nic = nicNumber.value.toLowerCase();

    int birthYear;
    int dayOfYear;
    bool isMale;

    if (isOldFormat.value) {
      // Extract year from old format (first 2 digits)
      final yearPrefix = int.parse(nic.substring(0, 2));
      // Determine if 19xx or 20xx based on the range
      birthYear = 1900 + yearPrefix;

      // Extract day of year from digits 3-5
      dayOfYear = int.parse(nic.substring(2, 5));

      // Check voting eligibility - v=can vote, x=cannot vote
      canVote.value = nic[9] == 'v' ? 'Yes' : 'No';
    } else {
      // Extract year from new format (first 4 digits)
      birthYear = int.parse(nic.substring(0, 4));

      // Extract day of year from digits 5-7
      dayOfYear = int.parse(nic.substring(4, 7));

      // New format doesn't show voting eligibility
      canVote.value = 'Not specified in new format';
    }

    // Determine gender based on day value
    if (dayOfYear > 500) {
      dayOfYear -= 500;
      isMale = false;
    } else {
      isMale = true;
    }

    gender.value = isMale ? 'Male' : 'Female';

    // Ensure day of year is valid
    if (dayOfYear < 1) dayOfYear = 1;
    if (dayOfYear > 366) {
      if (!_isLeapYear(birthYear) && dayOfYear > 365) {
        dayOfYear = 365;
      } else if (dayOfYear > 366) {
        dayOfYear = 366;
      }
    }

    // Calculate the actual birth date
    DateTime birthDate = _calculateDateFromDayOfYear(birthYear, dayOfYear);

    // Format date in a readable format (YYYY/MM/DD)
    dateOfBirth.value = DateFormat('yyyy/MM/dd').format(birthDate);

    // Get weekday name (e.g., "Thursday")
    weekdayName.value = DateFormat('EEEE').format(birthDate);

    // Calculate accurate age
    final today = DateTime.now();
    age.value = today.year -
        birthDate.year -
        ((today.month < birthDate.month ||
                (today.month == birthDate.month && today.day < birthDate.day))
            ? 1
            : 0);
  }

  /// Calculates a date from a year and day of year.
  ///
  /// Adds the day of year (minus 1) to January 1st of the specified year
  /// to get the actual date.
  ///
  /// [year] The year component of the date.
  /// [dayOfYear] The day of the year (1-366).
  ///
  /// Returns a [DateTime] object representing the calculated date.
  DateTime _calculateDateFromDayOfYear(int year, int dayOfYear) {
    // Directly add dayOfYear - 1 to January 1st
    return DateTime(year, 1, 1).add(Duration(days: dayOfYear - 1));
  }

  /// Checks if a year is a leap year.
  ///
  /// A year is a leap year if it is divisible by 4 but not by 100,
  /// or if it is divisible by 400.
  ///
  /// [year] The year to check.
  ///
  /// Returns true if the year is a leap year, false otherwise.
  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
