import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/emicalculator_controller.dart';

class EmiScheduleView extends StatelessWidget {
  EmiScheduleView({Key? key}) : super(key: key);

  final NumberFormat formatter = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    final EmicalculatorController controller =
        Get.find<EmicalculatorController>();
        

    return Scaffold(
      appBar: AppBar(
         iconTheme: IconThemeData(color: Colors.white), 
        backgroundColor: Colors.blueAccent,
        title: const Text("EMI Schedule",style:TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share),
          color: Colors.white,
           onPressed: () {
            shareEmiSchedule(controller);
           }),
          IconButton(icon: const Icon(Icons.print),
           color: Colors.white,
           onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Obx( ()=> Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                            child: DataTable(
                                columnSpacing: 20.0,
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
                                          DataCell(Text(formatter.format(
                                              double.parse(row["Payment"]!).round()))),
                                          DataCell(Text(formatter.format(
                                              double.parse(row["Principal"]!).round()))),
                                          DataCell(Text(formatter.format(
                                              double.parse(row["Interest"]!).round()))),
                                          DataCell(Text(formatter.format(
                                              double.parse(row["Balance"]!).round()))),
                                        ]))
                                    .toList()
                                  ..add(_buildTotalRow(controller)),
                                                      ),
                                                  
                              ),
                            ),
                          ),
                   ]
                )
              ),
            
          ),
        );
  }

  DataRow _buildTotalRow(EmicalculatorController controller) {
    int totalPayment = controller.emiSchedule
        .fold(0, (sum, row) => sum + double.parse(row["Payment"]!).round());
    int totalPrincipal = controller.emiSchedule
        .fold(0, (sum, row) => sum + double.parse(row["Principal"]!).round());
    int totalInterest = controller.emiSchedule
        .fold(0, (sum, row) => sum + double.parse(row["Interest"]!).round());

    return DataRow(
        color:
           MaterialStateProperty.all(const Color.fromARGB(255, 57, 255, 20)), // Neon Green
        cells: [
          const DataCell(
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(formatter.format(totalPayment).toString())),
          DataCell(Text(formatter.format(totalPrincipal).toString())),
          DataCell(Text(formatter.format(totalInterest).toString())),
          const DataCell(Text("-")),
        ]);
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