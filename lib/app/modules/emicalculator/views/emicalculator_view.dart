import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/emicalculator_controller.dart';
import 'emischedule.dart';
import 'widget.dart';

class EmicalculatorView extends GetView<EmicalculatorController> {
  const EmicalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the loan type from arguments
    final String loanType = Get.arguments ?? 'EMI Schedule';
    

    return Scaffold(
      appBar: AppBar(
        title:  Text(loanType),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: "Loan Amount (Principal)",
              inputFormatter: ThousandsSeparatorInputFormatter(),
              onChanged: (value) {
                controller.principal.value =
                    double.tryParse(value.replaceAll(',', '')) ?? 0.0;
              },
            ),
            _buildTextField(
              label: "Interest Rate (%)",
              onChanged: (value) {
                controller.rate.value = double.tryParse(value) ?? 0.0;
              },
            ),
            _buildTextField(
              label: "Tenure",
              onChanged: (value) {
                controller.tenure.value = int.tryParse(value) ?? 0;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: controller.tenureInMonths.value,
                        onChanged: (bool? value) {
                          controller.tenureInMonths.value = value ?? true;
                        },
                      ),
                      Text('Months'),
                    ],
                  ),
                ),
                Obx(() => Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: controller.tenureInMonths.value,
                          onChanged: (bool? value) {
                            controller.tenureInMonths.value = value ?? false;
                          },
                        ),
                        const Text('Years'),
                      ],
                    )),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.calculateEmi();

                // If there is an error message, show a SnackBar instead of navigating
                if (controller.errorMessage.value.isNotEmpty) {
                  Get.snackbar(
                    "Error",
                    controller.errorMessage.value,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                // Only navigate if there are no errors
                Get.to(() => EmiScheduleView(),arguments: controller.loanType.value);
              },
              child: const Text('Calculate EMI'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom TextField with optional input formatter
Widget _buildTextField({
  required String label,
  TextInputFormatter? inputFormatter,
  required Function(String) onChanged,
}) {
  return TextField(
    keyboardType: TextInputType.number,
    inputFormatters: inputFormatter != null ? [inputFormatter] : [],
    decoration: InputDecoration(labelText: label),
    onChanged: onChanged,
  );
}
