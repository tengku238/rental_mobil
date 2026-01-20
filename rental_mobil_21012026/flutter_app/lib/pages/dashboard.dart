import 'package:flutter/material.dart';
import 'home.dart';
import 'car_list.dart';
import 'contact_us.dart';

class DashboardPage extends StatefulWidget {
  final String email;
  const DashboardPage({super.key, required this.email});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color themeYellow = const Color(0xFFF9B233);
  String _userName = "User"; 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 800; // Ambang batas untuk menampilkan navbar teks
        final horizontalPadding = isMobile ? 24.0 : 60.0;

        return Scaffold(
          extendBodyBehindAppBar: true,
          // APPBAR DENGAN MENU DI SEBELAH USER
          appBar: _buildAppBar(context, isMobile),
          body: Stack(
            children: [
              // ================= BACKGROUND IMAGE =================
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?q=80&w=1983',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),

              // ================= CONTENT =================
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Memusatkan teks hero
                    children: [
                      _buildHeroSection(isMobile),
                      const SizedBox(height: 100), // Memberi ruang di bawah
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // --- NAVBAR (APPBAR) DENGAN MENU ---
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMobile) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // MENGHAPUS TOMBOL GARIS 3 (DRAWER)
      title: Row(
        children: [
          Icon(Icons.directions_car, color: themeYellow),
          const SizedBox(width: 8),
          const Text(
            "CarRide", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)
          ),
        ],
      ),
      actions: [
        // MENU NAVBAR (Hanya muncul jika layar cukup lebar)
        if (!isMobile) ...[
          _navActionText("DAFTAR MOBIL", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CarListPage(email: widget.email)));
          }),
          _navActionText("CONTACT US", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsPage()));
          }),
          _navActionText("LOGOUT", () => _handleLogout(context), isLogout: true),
        ],
        
        // JIKA MOBILE, GUNAKAN ICON AGAR TIDAK SESAK
        if (isMobile) ...[
          IconButton(
            icon: const Icon(Icons.directions_car_filled, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CarListPage(email: widget.email))),
          ),
          IconButton(
            icon: const Icon(Icons.support_agent, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsPage())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => _handleLogout(context),
          ),
        ],

        const SizedBox(width: 10),
        
        // PROFIL USER
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: themeYellow,
            child: Text(
              _userName[0].toUpperCase(), 
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ],
    );
  }

  // Widget pembantu untuk teks di Navbar
  Widget _navActionText(String title, VoidCallback onTap, {bool isLogout = false}) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    double titleSize = isMobile ? 36 : 64;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WELCOME BACK,",
          style: TextStyle(
            fontSize: 16,
            color: themeYellow,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "LUXURY",
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        Text(
          "LIFESTYLE",
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w900, color: Colors.white, height: 0.9),
        ),
        Text(
          "RENTALS",
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w900, color: themeYellow, height: 0.9),
        ),
        const SizedBox(height: 20),
        const Text(
          "Ready to drive your dreams today?",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => const HomePage()), 
      (route) => false
    );
  }
}