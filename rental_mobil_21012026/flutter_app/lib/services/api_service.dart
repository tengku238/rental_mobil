import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  /* ===================== AUTH ===================== */

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "profile_image": "", // ✅ DEFAULT KOSONG
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /* ===================== CARS ===================== */

  static Future<List<dynamic>> getCars() async {
    final response = await http.get(Uri.parse("$baseUrl/cars"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data mobil");
    }
  }

  static Future<bool> addCar(Map<String, dynamic> carData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/cars"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(carData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Server Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Connection Error: $e");
      return false;
    }
  }

  /* ===================== BOOKING ===================== */

  static Future<Map<String, dynamic>> bookCar({
    required String email,
    required int carId,
    required int days,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/booking"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "car_id": carId,
        "days": days,
        "payment_method": paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Booking gagal: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    final response = await http.get(Uri.parse("$baseUrl/booking/$bookingId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data booking");
    }
  }
}
