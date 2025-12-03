import 'package:shared_preferences/shared_preferences.dart';

///////////////////////////////changed for the emulator ////////""http://10.0.2.2:4000"
//////////////////////////////changed for default ///////////http://localhost:4000
/////////////////////////////http://192.168.1.103:4000
//////////////////////////////for sharing and runing other device the mobile and the laptop should be on the same network then run ipconfig on cmd then take you laptop ip4 address ////
class AppUrls {
  static String _baseUrl = "http://192.168.001.117:4000"; // default

  /// Initialize from SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString('baseUrl') ?? _baseUrl;
  }

  static String get baseUrl => _baseUrl;

  /// Auth
  static String get register => "$baseUrl/api/users/register";

  static String get login => "$baseUrl/api/users/login";

  static String get getCurrentUser => "$baseUrl/api/users/me";

  static String get contactForm => "$baseUrl/api/forms/submit";

  static String get refreshToken => "$baseUrl/api/users/refresh-token";

  /// Properties
  static String get searchProperties => "$baseUrl/api/properties/search";

  static String get getProperties => "$baseUrl/api/products/list";

  static String get getUserWishlist => "$baseUrl/api/users/wishlist";

  static String get addPropertyToWishList => "$baseUrl/api/users/wishlist/add";

  static String get removePropertyToWishList => "$baseUrl/api/users/wishlist/remove";

  static String get getSingleProperty => "$baseUrl/api/products/single/:id";

  /// Appointments
  static String get scheduleAppointment => "$baseUrl/api/appointments/schedule";

  static String get getAppointmentsByUser => "$baseUrl/api/appointments/user";

  /// Amenities
  static String get getAmenities => "$baseUrl/api/products/amenities";

  /// Stats
  static String get statusDistribution => "$baseUrl/api/reviews";

  static String get getViewsOverTime => "$baseUrl/api/products/views-over-time";

  /// Reviews
  static String getReviewsByProperty(String propertyId) => "$baseUrl/api/reviews/property/$propertyId";

  static String get addReview => "$baseUrl/api/reviews";

  /// Cities
  static String get getCities => "$baseUrl/api/cities";

  /// Admin
  static String get adminStatsUrl => "$baseUrl/api/admin/stats";

  /// News
  static String get getNews => "$baseUrl/api/news/news";

  /// Transactions
  static String get getViews => "$baseUrl/api/products/total-views";

  static String get getCompletedTransaction => "$baseUrl/api/transactions/count/completed";
}
