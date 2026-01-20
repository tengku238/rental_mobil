import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class SuratService {
  static Future<void> cetakSurat({
    required String email,
    required String carName,
    required int pricePerDay,
    required int days,
    required int total,
    required String paymentMethod,
    required int bookingId,
  }) async {
    final pdf = pw.Document();
    final fontReg = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: fontReg, bold: fontBold),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("RENTAL SEWA MOBIL", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Invoice Sewa Mobil", style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text("Pelanggan: $email"),
              pw.SizedBox(height: 5),
              pw.Text("Tanggal: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}"),
              pw.SizedBox(height: 5),
              pw.Text("Metode Pembayaran: $paymentMethod"),
              pw.SizedBox(height: 5),
              pw.Text("ID Booking: $bookingId"),
              pw.SizedBox(height: 10),
              pw.Text("Waktu: ${DateFormat('HH:mm').format(DateTime.now())}"),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headers: ['Deskripsi', 'Durasi', 'Harga', 'Total'],
                data: [
                  [carName, '$days Hari', currency.format(pricePerDay), currency.format(total)],
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text("Tanggal Kembali: ${DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: days)))}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "TOTAL PEMBAYARAN: ${currency.format(total)}",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Spacer(),
              pw.Center(child: pw.Text("Dokumen ini adalah bukti pembayaran elektronik yang sah.")),
            ],
          );
        },
      ),
    );
    

    await Printing.layoutPdf(
      name: 'Invoice_${carName.replaceAll(' ', '_')}.pdf',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}