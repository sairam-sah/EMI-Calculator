import 'dart:math';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';


class EmicalculatorController extends GetxController {
 final RxString errorMessage = "".obs; 

  // Input fields
  var principal = 100000.0.obs;
  var rate = 8.5.obs;
  var tenure = 120.obs;
  var tenureInMonths = true.obs;
  var loanType = 'Flat'.obs; // Default loan type

  // Output fields
  var emi = 0.0.obs;
  var totalInterest = 0.0.obs;
  var totalPayment = 0.0.obs;
  var emiSchedule = <Map<String, String>>[].obs;

  void calculateEmi() {
  // Ensure input fields have values
  if (principal.value == 100000.0 && GetUtils.isNullOrBlank(Get.arguments) == true) {
    errorMessage.value = "Please enter a valid loan amount.";
    return;
  }
  if (rate.value == 8.5 && GetUtils.isNullOrBlank(Get.arguments) == true) {
    errorMessage.value = "Please enter a valid interest rate.";
    return;
  }
  if (tenure.value == 120 && GetUtils.isNullOrBlank(Get.arguments) == true) {
    errorMessage.value = "Please enter a valid tenure.";
    return;
  }

   // Clear any previous error messages
  errorMessage.value = "";

    final double monthlyRate = rate.value / 12 / 100;
    final int timeInMonths = tenureInMonths.value ? tenure.value : tenure.value * 12;
    
       if (loanType.value == 'Flat') {
      _calculateFlatEmi(timeInMonths, monthlyRate);
    } else if (loanType.value == 'Declining') {
      _calculateDecliningEmi(timeInMonths, monthlyRate);
    } else if (loanType.value == 'Interest_Only') {
      _calculateInterestOnlyEmi(timeInMonths, monthlyRate);
    }
  
  }



 /// 🔹 Function to Share EMI Details
  void shareEmiSchedule(EmicalculatorController controller) {
    String emiDetails = "EMI Schedule for ${controller.loanType.value} Loan:\n\n";

    for (var row in controller.emiSchedule) {
      emiDetails +=
          "Month: ${row["No"]}, Payment: ${row["Payment"]}, Principal: ${row["Principal"]}, Interest: ${row["Interest"]}, Balance: ${row["Balance"]}\n";
    }

    // Share the details
    Share.share(emiDetails);
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

    _generateFlatEmiSchedule(timeInMonths, monthlyRate);
  }

  /// **Declining EMI Calculation**
  void _calculateDecliningEmi(int timeInMonths, double monthlyRate) {
    emiSchedule.clear();
    double remainingBalance = principal.value;
    double principalComponent = principal.value / timeInMonths;
    totalInterest.value = 0.0;
    totalPayment.value = 0.0;

    for (int month = 1; month <= timeInMonths; month++) {
      double interest = remainingBalance * monthlyRate;
      double emiValue = principalComponent + interest;

      totalInterest.value += interest;
      totalPayment.value += emiValue;

      remainingBalance -= principalComponent;

      emiSchedule.add({
        "No": month.toString(),
        "Payment": emiValue.toStringAsFixed(2),
        "Principal": principalComponent.toStringAsFixed(2),
        "Interest": interest.toStringAsFixed(2),
        "Balance": remainingBalance.isNegative ? "0.00" : remainingBalance.toStringAsFixed(2),
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
        "Principal": (month == timeInMonths ? principal.value.toStringAsFixed(2) : "0.00"),
        "Interest": monthlyInterest.toStringAsFixed(2),
        "Balance": (month == timeInMonths ? "0.00" : principal.value.toStringAsFixed(2)),
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
        "Balance": remainingPrincipal.isNegative ? "0.00" : remainingPrincipal.toStringAsFixed(2),
      });

      if (remainingPrincipal <= 0) break;
    }
  }




  
  @override
  void onInit() {
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
