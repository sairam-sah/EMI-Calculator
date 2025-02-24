import 'package:easyemi/app/modules/emicalculator/controllers/shareemi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/emicalculator_controller.dart';
import '../controllers/printemi.dart';

class EmiScheduleView extends StatelessWidget {
  EmiScheduleView({Key? key}) : super(key: key);

  final NumberFormat formatter = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final EmicalculatorController controller =
        Get.find<EmicalculatorController>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        title:
            const Text("EMI Schedule", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.share),
              color: Colors.white,
              onPressed: () async {
                  if (controller.emiSchedule.isNotEmpty) {
                await shareEmiSchedule(controller);
              } else {
                print("No EMI schedule available for printing.");
              }
              }),
          IconButton(
            icon: const Icon(Icons.print),
            color: Colors.white,
            onPressed: () async {
              if (controller.emiSchedule.isNotEmpty) {
                await printEmiSchedule(controller);
              } else {
                print("No EMI schedule available for printing.");
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Obx(() => Column(children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 15,
                      border: TableBorder.all(),
                      columns: const [
                        DataColumn(label: Text("No.")),
                        DataColumn(label: Text("Payment")),
                        DataColumn(label: Text("Principal")),
                        DataColumn(label: Text("Interest")),
                        DataColumn(label: Text("Balance")),
                      ],
                      rows: controller.emiSchedule
                          .map((row) => DataRow(cells: [
                                DataCell(Text(row["No"].toString())),
                                DataCell(Text(formatter
                                    .format(double.parse(row["Payment"]!)))),
                                DataCell(Text(formatter
                                    .format(double.parse(row["Principal"]!)))),
                                DataCell(Text(formatter
                                    .format(double.parse(row["Interest"]!)))),
                                DataCell(Text(formatter
                                    .format(double.parse(row["Balance"]!)))),
                              ]))
                          .toList()
                        ..add(_buildTotalRow(controller)),
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }

  DataRow _buildTotalRow(EmicalculatorController controller) {
    double totalPayment = controller.emiSchedule
        .fold(0.0, (sum, row) => sum + double.parse(row["Payment"]!));
    double totalPrincipal = controller.emiSchedule
        .fold(0.0, (sum, row) => sum + double.parse(row["Principal"]!));
    double totalInterest = controller.emiSchedule
        .fold(0.0, (sum, row) => sum + double.parse(row["Interest"]!));

    return DataRow(
        color: MaterialStateProperty.all(
            const Color.fromARGB(255, 57, 255, 20)), // Neon Green
        cells: [
          const DataCell(
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(formatter.format(totalPayment))),
          DataCell(Text(formatter.format(totalPrincipal))),
          DataCell(Text(formatter.format(totalInterest))),
          const DataCell(Text("-")),
        ]);
  }
}




