import 'dart:math';
import 'package:get/get.dart';


class EmicalculatorController extends GetxController {
  final RxString errorMessage = "".obs;

  // Input fields
  var principal = 100000.0.obs;
  var rate = 8.5.obs;
  var tenure = 120.obs;
  var tenureInMonths = true.obs;
  var loanType = 'Flat Interest Loan'.obs; // Default loan type

  // Output fields
  var emi = 0.0.obs;
  var totalInterest = 0.0.obs;
  var totalPayment = 0.0.obs;
  var emiSchedule = <Map<String, String>>[].obs;

  void calculateEmi() {
    // Ensure input fields have values
    if (principal.value <= 0 || rate.value <= 0 || tenure.value <= 0) {
      errorMessage.value = "Please enter valid values for all fields.";
      return;
    }
    // Clear any previous error messages
    errorMessage.value = "";

    final double monthlyRate = rate.value / 12 / 100;
    final int timeInMonths =
        tenureInMonths.value ? tenure.value : tenure.value * 12;

    if (loanType.value == 'Flat Interest Loan') {
      _calculateFlatEmi(timeInMonths, monthlyRate);
      _generateFlatEmiSchedule(timeInMonths, monthlyRate);
    } else if (loanType.value == 'Declining Interest Loan') {
      _calculateDecliningEmi(timeInMonths, monthlyRate);
      _generateDecliningEmiSchedule(timeInMonths, monthlyRate);
    } else if (loanType.value == 'Interest-Only Loan') {
      _calculateInterestOnlyEmi(timeInMonths, monthlyRate);
      _generateInterestOnlyEmiSchedule(timeInMonths, monthlyRate);
    }
  }

  /// **Flat EMI Calculation*
  void _calculateFlatEmi(int timeInMonths, double monthlyRate) {
    if (monthlyRate == 0) {
      emi.value = principal.value / timeInMonths;
    } else {
      final double numerator = monthlyRate * pow(1 + monthlyRate, timeInMonths);
      final double denominator = pow(1 + monthlyRate, timeInMonths) - 1;
      emi.value = principal.value * (numerator / denominator);
    }

    totalPayment.value = emi.value * timeInMonths;
    totalInterest.value = totalPayment.value - principal.value;

    // Adjust for the last month and generate EMI schedule
    double remainingPrincipal = principal.value;
    emiSchedule.clear();

    for (int month = 1; month <= timeInMonths; month++) {
      // Calculate monthly interest
      double monthlyInterest = remainingPrincipal * monthlyRate;
      double principalComponent = emi.value - monthlyInterest;

      // In the final month, adjust the principal component to clear the remaining balance
      if (month == timeInMonths) {
        principalComponent =
            remainingPrincipal; // Pay off the remaining balance
        emi.value = principalComponent + monthlyInterest; // Final EMI
      }

      // Update remaining principal after payment
      remainingPrincipal = remainingPrincipal - principalComponent;

      // Add schedule details for the month
      emiSchedule.add({
        "No": month.toString(),
        "Payment": emi.value.toStringAsFixed(2),
        "Principal": principalComponent.toStringAsFixed(2),
        "Interest": monthlyInterest.toStringAsFixed(2),
        "Balance": remainingPrincipal.isNegative
            ? "0.00"
            : remainingPrincipal.toStringAsFixed(2),
      });

      // Break if the principal is fully paid off
      if (remainingPrincipal <= 0) break;
    }
  }

  double roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// **Declining EMI Calculation**
  void _calculateDecliningEmi(int timeInMonths, double monthlyRate) {
    emiSchedule.clear();
    double remainingBalance = principal.value;
    double principalComponent =
        roundToTwoDecimals(principal.value / timeInMonths);

    for (int month = 1; month <= timeInMonths; month++) {
      double interest = roundToTwoDecimals(remainingBalance * monthlyRate);
      double emiValue;

      if (month == timeInMonths) {
        principalComponent = remainingBalance;
        emiValue = principalComponent + interest;
      } else {
        emiValue = roundToTwoDecimals(principalComponent + interest);
      }

      remainingBalance = roundToTwoDecimals(remainingBalance - principalComponent);

      emiSchedule.add({
        "No": month.toString(),
        "Payment": emiValue.toStringAsFixed(2),
        "Principal": principalComponent.toStringAsFixed(2),
        "Interest": interest.toStringAsFixed(2),
        "Balance": remainingBalance.isNegative
            ? "0.00"
            : remainingBalance.toStringAsFixed(2),
      });

      if (remainingBalance <= 0) break;
    }
  }

  /// **Interest-Only EMI Calculation (Corrected)**
  void _calculateInterestOnlyEmi(int timeInMonths, double monthlyRate) {
    emiSchedule.clear();
    double monthlyInterest = principal.value * monthlyRate;
    totalInterest.value = 0.0;
    totalPayment.value = 0.0;

    for (int month = 1; month <= timeInMonths; month++) {
      double emiValue;

      if (month == timeInMonths) {
        // Last month: Pay interest + principal
        emiValue = principal.value + monthlyInterest;
      } else {
        // Monthly interest-only payment
        emiValue = monthlyInterest;
      }

      totalInterest.value += monthlyInterest;
      totalPayment.value += emiValue;

      emiSchedule.add({
        "No": month.toString(),
        "Payment": emiValue.toStringAsFixed(2),
        "Principal": (month == timeInMonths
            ? principal.value.toStringAsFixed(2)
            : "0.00"),
        "Interest": monthlyInterest.toStringAsFixed(2),
        "Balance": (month == timeInMonths
            ? "0.00"
            : principal.value.toStringAsFixed(2)),
      });
    }
  }

  /// **Flat EMI Schedule Generation**
  void _generateFlatEmiSchedule(int timeInMonths, double monthlyRate) {
    emiSchedule.clear();
    double remainingPrincipal = principal.value;

    for (int month = 1; month <= timeInMonths; month++) {
      double monthlyInterest = remainingPrincipal * monthlyRate;
      double principalComponent = emi.value - monthlyInterest;

      remainingPrincipal -= principalComponent;

      emiSchedule.add({
        "No": month.toString(),
        "Payment": emi.value.toStringAsFixed(2),
        "Principal": principalComponent.toStringAsFixed(2),
        "Interest": monthlyInterest.toStringAsFixed(2),
        "Balance": remainingPrincipal.isNegative
            ? "0.00"
            : (remainingPrincipal).toStringAsFixed(2),
      });

      if (remainingPrincipal <= 0) break;
    }
  }

  void _generateDecliningEmiSchedule(int timeInMonths, double monthlyRate) {
    emiSchedule.clear();
    double remainingBalance = principal.value;
    double principalComponent =roundToTwoDecimals( principal.value / timeInMonths);

    for (int month = 1; month <= timeInMonths; month++) {
      double interest = remainingBalance * monthlyRate;
      double emiValue;

        if (month == timeInMonths) {
        principalComponent = remainingBalance;
        emiValue = principalComponent + interest;
      } else {
        emiValue = roundToTwoDecimals(principalComponent + interest);
      }

      remainingBalance -= principalComponent;

      emiSchedule.add({
        "No": month.toString(),
        "Payment": emiValue.toStringAsFixed(2),
        "Principal": principalComponent.toStringAsFixed(2),
        "Interest": interest.toStringAsFixed(2),
        "Balance": remainingBalance.isNegative
            ? "0.00"
            : remainingBalance.toStringAsFixed(2),
      });

      if (remainingBalance <= 0) break;
    }
  }

  void _generateInterestOnlyEmiSchedule(int timeInMonths, double monthlyRate) {
    emiSchedule.clear();
    double monthlyInterest = principal.value * monthlyRate;

    for (int month = 1; month <= timeInMonths; month++) {
      double emiValue = monthlyInterest;

      // Last month: Pay both interest and principal
      if (month == timeInMonths) {
        emiValue += principal.value;
      }

      emiSchedule.add({
        "No": month.toString(),
        "Payment": emiValue.toStringAsFixed(2),
        "Principal": (month == timeInMonths
            ? principal.value.toStringAsFixed(2)
            : "0.00"),
        "Interest": monthlyInterest.toStringAsFixed(2),
        "Balance": (month == timeInMonths
            ? "0.00"
            : principal.value.toStringAsFixed(2)),
      });
    }
  }






  @override
  void onInit() {
    loanType.value = Get.arguments ?? 'Flat Interest Loan';
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
