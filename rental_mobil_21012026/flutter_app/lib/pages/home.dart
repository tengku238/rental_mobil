import 'package:flutter/material.dart';
import 'login.dart';
import 'contact_us.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1100;

        final horizontalPadding = isMobile ? 30.0 : 80.0;
        final titleSize = isMobile ? 32.0 : (isTablet ? 48.0 : 64.0);

        return Scaffold(
          // ================= DRAWER (MENU MOBILE) =================
          drawer: isMobile ? _buildDrawer(context) : null,
          
          body: Stack(
            children: [
              // ================= BACKGROUND IMAGE =================
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=2070',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

              // ================= CONTENT OVERLAY =================
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= NAVBAR =================
                      _buildNavbar(context, isMobile),

                      const Spacer(),

                      // ================= HERO SECTION =================
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LUXURY',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'LIFESTYLE',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            'RENTALS',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFF9B233),
                              letterSpacing: 2,
                              height: 0.9,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Enjoy the most luxurious experience with our\npremium car rental service.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            ),
                          const SizedBox(height: 40),
                          
                          
                        ],
                      ),
                      const Spacer(flex: 2),
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

  // ================= WIDGET NAVBAR =================
  Widget _buildNavbar(BuildContext context, bool isMobile) {
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: const [
              Icon(Icons.directions_car, color: Color(0xFFF9B233), size: 30),
              SizedBox(width: 10),
              Text(
                'AUTOCAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          if (!isMobile)
            Row(
              children: [
                _navItem("Home", isActive: true),
                _navItem("Contact Us", onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsPage()));
                }),
                const SizedBox(width: 20),
                _buildLoginButton(context),
              ],
            )
          else
            // Tombol Hamburger Menu untuk Mobile
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
        ],
      ),
    );
  }

  // ================= WIDGET DRAWER (MENU SAMPING) =================
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.9),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFF9B233)),
            child: Center(
              child: Text(
                'AUTOCAR MENU',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _drawerItem(Icons.home, "Home", () => Navigator.pop(context)),
          _drawerItem(Icons.contact_support, "Contact Us", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsPage()));
          }),
          _drawerItem(Icons.login, "Login", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _navItem(String title, {bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF9B233),
        foregroundColor: Colors.black,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      ),
      child: const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}