import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'emicalculator_controller.dart';

Future<void> shareEmiSchedule(EmicalculatorController controller) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "EMI Schedule",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ["No", "Payment", "Principal", "Interest", "Balance"],
              data: controller.emiSchedule.map((item) {
                return [
                  item["No"],
                  item["Payment"],
                  item["Principal"],
                  item["Interest"],
                  item["Balance"]
                ];
              }).toList(),
            ),
          ],
        );
      },
    ),
  );

  try {
    // Get a temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = "${directory.path}/emi_schedule.pdf";

    // Save PDF to file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Share the PDF
    await Share.shareXFiles([XFile(filePath)], text: "Here is your EMI Schedule PDF");
  } catch (e) {
    print("Error sharing PDF: $e");
  }
}
