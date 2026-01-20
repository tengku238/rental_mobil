import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfInvoice {
  static Future<void> generate({
    required String carName,
    required int pricePerDay,
    required int days,
    required int total,
    required String email,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "BUKTI PEMESANAN RENTAL MOBIL",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),

                pw.Divider(),

                pw.Text("Mobil        : $carName"),
                pw.Text("Harga / Hari : Rp $pricePerDay"),
                pw.Text("Jumlah Hari  : $days"),
                pw.Text("Penyewa      : $email"),

                pw.SizedBox(height: 20),

                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "TOTAL BAYAR",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "Rp $total",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                pw.Spacer(),

                pw.Text(
                  "Terima kasih telah menggunakan layanan Rental Mobil kami.",
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  "Dokumen ini sah dan dapat digunakan sebagai bukti sewa.",
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Preview + Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
