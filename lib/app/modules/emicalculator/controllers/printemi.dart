import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'emicalculator_controller.dart'; 

Future<void> printEmiSchedule(EmicalculatorController controller) async {
  if (controller.emiSchedule.isEmpty) {
    print("No EMI schedule data to print.");
    return;
  }

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
                  item["No"].toString(),
                  item["Payment"].toString(),
                  item["Principal"].toString(),
                  item["Interest"].toString(),
                  item["Balance"].toString(),
                ];
              }).toList(),
            ),
          ],
        );
      },
    ),
  );

  // Print the generated PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
