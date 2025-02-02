import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../emicalculator/views/emicalculator_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy EMI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon:
                  const Icon(Icons.account_balance, size: 28), // Flat Loan Icon
              label: const Text(
                "Flat Interest Loan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                backgroundColor: Colors.blue, // Change to your preferred color
                foregroundColor: Colors.white, // Text & Icon Color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  Get.to(() => EmicalculatorView(), arguments: 'Flat'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.EMICALCULATOR, arguments: 'Declining');
              },
              child: const Text('Declining Balance'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.EMICALCULATOR, arguments: 'Interest_Only');
              },
              child: const Text('Interest Only'),
            ),
          ],
        ),
      ),
    );
  }
}
