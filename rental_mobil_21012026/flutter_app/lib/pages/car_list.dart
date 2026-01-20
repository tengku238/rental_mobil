import 'package:Sewa_mobil/pages/checkout.dart';
import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/api_service.dart';

class CarListPage extends StatefulWidget {
  final String email;
  const CarListPage({super.key, required this.email});

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  // --- KONFIGURASI TEMA UI KONSISTEN ---
  final Color themeYellow = const Color(0xFFF9B233);
  final Color themeBlack = const Color(0xFF212121);

  List<Car> allCars = [];
  List<Car> filteredCars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      final data = await ApiService.getCars();
      final cars = data.map<Car>((e) => Car.fromJson(e)).toList();
      setState(() {
        allCars = cars;
        filteredCars = cars;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCars = allCars;
      } else {
        filteredCars = allCars.where((car) =>
            car.brand.toLowerCase().contains(query.toLowerCase()) ||
            car.model.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Agar background menyatu ke atas
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "DAFTAR MOBIL",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
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
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1983'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.8)), // Lebih gelap untuk list
          ),

          // ================= CONTENT =================
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: themeYellow))
                      : filteredCars.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: filteredCars.length,
                              itemBuilder: (context, index) =>
                                  _buildCarCard(filteredCars[index]),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: _filterSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Cari brand atau tipe mobil...",
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: themeYellow),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: themeYellow),
          ),
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          children: [
            // Image Section
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.network(
                      car.imageUrl.toString(),
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) =>
                          Icon(Icons.directions_car, size: 50, color: themeYellow),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: car.status == 'available' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      car.status.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car.brand.toUpperCase(),
                              style: TextStyle(color: themeYellow, fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(car.model,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 16, color: themeYellow),
                            const SizedBox(width: 4),
                            Text(car.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildSpecIcon(Icons.settings, car.transmission),
                      const SizedBox(width: 15),
                      _buildSpecIcon(Icons.local_gas_station, "Petrol"),
                    ],
                  ),
                  const Divider(height: 30, color: Colors.white24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Harga Sewa", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text("Rp ${car.pricePerDay}",
                              style: TextStyle(color: themeYellow, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(car: car, email: widget.email),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeYellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        ),
                        child: const Text("SEWA SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: themeYellow),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.white24),
          const SizedBox(height: 10),
          const Text("Mobil tidak ditemukan...", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}