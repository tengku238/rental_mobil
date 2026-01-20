import 'package:flutter/material.dart';
import 'surat_service.dart';
import '../models/car_model.dart';
import '../services/api_service.dart';

class CheckoutPage extends StatefulWidget {
  final Car car;
  final String email;

  const CheckoutPage({super.key, required this.car, required this.email});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _daysController = TextEditingController();
  final Color themeYellow = const Color(0xFFF9B233);
  
  int _total = 0;
  bool _isProcessing = false;
  String _paymentMethod = "Cash";
  final List<String> _paymentMethods = ["Cash", "Transfer"];

  @override
  void initState() {
    super.initState();
    _daysController.addListener(_hitungTotal);
  }

  void _hitungTotal() {
    final int hari = int.tryParse(_daysController.text) ?? 0;
    setState(() {
      _total = hari * widget.car.pricePerDay;
    });
  }

  Future<void> _handleCheckout() async {
    final int days = int.tryParse(_daysController.text) ?? 0;
    if (days <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Durasi sewa tidak valid")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final result = await ApiService.bookCar(
        email: widget.email,
        carId: widget.car.id,
        days: days,
        paymentMethod: _paymentMethod,
      );

      final String carName = "${widget.car.brand} ${widget.car.model}";

      await SuratService.cetakSurat(
        email: widget.email,
        carName: carName,
        pricePerDay: widget.car.pricePerDay,
        days: days,
        total: _total,
        paymentMethod: _paymentMethod,
        bookingId: result["booking_id"],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text("Booking berhasil!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Booking gagal: $e")),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String carName = "${widget.car.brand} ${widget.car.model}";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("CHECKOUT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // ================= BACKGROUND IMAGE =================
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1983'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
          // ================= CONTENT =================
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              child: Column(
                children: [
                  // Glassmorphism Card
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(carName.toUpperCase(), 
                          style: TextStyle(color: themeYellow, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                        const Text("Review pesanan Anda di bawah ini", 
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(color: Colors.white24),
                        ),

                        // Input Durasi
                        _buildLabel("Durasi Sewa"),
                        TextField(
                          controller: _daysController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Jumlah Hari", Icons.calendar_month_outlined),
                        ),

                        const SizedBox(height: 20),

                        // Dropdown Payment
                        _buildLabel("Metode Pembayaran"),
                        DropdownButtonFormField<String>(
                          value: _paymentMethod,
                          dropdownColor: const Color(0xFF212121),
                          style: const TextStyle(color: Colors.white),
                          items: _paymentMethods.map((method) {
                            return DropdownMenuItem(value: method, child: Text(method));
                          }).toList(),
                          onChanged: (value) => setState(() => _paymentMethod = value!),
                          decoration: _inputDecoration("Pilih Metode", Icons.payment_outlined),
                        ),

                        const SizedBox(height: 30),

                        // Ringkasan Harga
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("TOTAL BAYAR", 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text("Rp $_total", 
                                style: TextStyle(color: themeYellow, fontSize: 22, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        // Tombol Konfirmasi
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _handleCheckout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeYellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            child: _isProcessing 
                              ? const CircularProgressIndicator(color: Colors.black)
                              : const Text("KONFIRMASI & CETAK", 
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets & Styles
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30),
      prefixIcon: Icon(icon, color: themeYellow, size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: themeYellow),
      ),
    );
  }
}