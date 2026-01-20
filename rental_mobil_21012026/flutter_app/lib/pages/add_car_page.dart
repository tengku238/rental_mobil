import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  String _transmission = 'Auto';

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
    // Pastikan semua field ini ADA di database Anda
    final Map<String, dynamic> carData = {
      "brand": _brandController.text,
      "model": _modelController.text,
      "price_per_day": int.parse(_priceController.text), // Pastikan diconvert ke INT
      "transmission": _transmission, // 'Auto' atau 'Manual'
      "rating": double.parse(_ratingController.text), // Pastikan diconvert ke DOUBLE
      "image_url": _imageController.text,
      "status": "available", // Field wajib
      "description": "Kapasitas 4 orang", // Tambahkan jika database memintanya
    };

    bool success = await ApiService.addCar(carData);
    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan mobil")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Mobil Baru")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(controller: _brandController, decoration: const InputDecoration(labelText: "Brand (Contoh: Toyota)")),
            TextFormField(controller: _modelController, decoration: const InputDecoration(labelText: "Model (Contoh: Agya)")),
            TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: "Harga per Hari"), keyboardType: TextInputType.number),
            TextFormField(controller: _ratingController, decoration: const InputDecoration(labelText: "Rating (1.0 - 5.0)"), keyboardType: TextInputType.number),
            TextFormField(controller: _imageController, decoration: const InputDecoration(labelText: "URL Gambar")),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: _transmission,
              items: ['Auto', 'Manual'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) => setState(() => _transmission = val.toString()),
              decoration: const InputDecoration(labelText: "Transmisi"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFDB827)),
              child: const Text("SIMPAN MOBIL"),
            )
          ],
        ),
      ),
    );
  }
}