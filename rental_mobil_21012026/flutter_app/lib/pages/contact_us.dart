import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  final Color themeYellow = const Color(0xFFF9B233);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 800;
        final horizontalPadding = isMobile ? 24.0 : 60.0;

        return Scaffold(
          extendBodyBehindAppBar: true,
          // APPBAR KONSISTEN DENGAN DASHBOARD TANPA NAVIGASI CAR LIST
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
                  color: Colors.black.withOpacity(0.7), // Overlay lebih gelap untuk fokus konten
                ),
              ),

              // ================= CONTENT =================
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Container(
                      width: isMobile ? double.infinity : 500,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1), // Efek Glassmorphism
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: themeYellow.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.support_agent, size: 48, color: themeYellow),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "CONTACT US",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Kami siap melayani kebutuhan perjalanan Anda",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 40),
                          
                          // Contact Details
                          _contactItem(Icons.email_outlined, "owner@rentalmobil.com"),
                          const SizedBox(height: 20),
                          _contactItem(Icons.phone_outlined, "+62 812 3456 7890"),
                          const SizedBox(height: 20),
                          _contactItem(Icons.location_on_outlined, "Jakarta, Indonesia"),
                          
                          const SizedBox(height: 40),
                          
                          // Back Button
                          SizedBox(width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: themeYellow, width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: Text(
                                "KEMBALI",
                                style: TextStyle(color: themeYellow, fontWeight: FontWeight.bold, letterSpacing: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- NAVBAR (APPBAR) ---
  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMobile) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Icon(Icons.directions_car, color: themeYellow),
          const SizedBox(width: 8),
          const Text("CarRide", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
      actions: [
        if (!isMobile) ...[
          // Hanya menyisakan navigasi aktif untuk halaman ini saja
          _navActionText("CONTACT US", () {}, isActive: true),
        ],
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _navActionText(String title, VoidCallback onTap, {bool isActive = false}) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? themeYellow : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: themeYellow, size: 24),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}