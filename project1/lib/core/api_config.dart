class ApiConfig {
  static const String baseUrl = 'https://mortally-egotistic-presume.ngrok-free.dev/api';
 
  // Transactions
  static Uri transactions() => Uri.parse('$baseUrl/transactions');
  static Uri transaction(String id) => Uri.parse('$baseUrl/transactions/$id');
 
  // Categories
  static Uri categories() => Uri.parse('$baseUrl/categories');
  static Uri category(int id) => Uri.parse('$baseUrl/categories/$id');
 
  // Notifications
  static Uri notifications() => Uri.parse('$baseUrl/notifications');
  static Uri notificationsUnread() => Uri.parse('$baseUrl/notifications/unread');
  static Uri notificationRead(int id) =>
      Uri.parse('$baseUrl/notifications/$id/read');
  static Uri notificationsReadAll() =>
      Uri.parse('$baseUrl/notifications/read-all');
 
  // Budget targets
  static Uri budgetTargets() => Uri.parse('$baseUrl/budget-targets');
  static Uri budgetTarget(int id) => Uri.parse('$baseUrl/budget-targets/$id');
 
  // Statistics — с опциональным ?month=
  static Uri statisticsSummary({String? month}) =>
      Uri.parse('$baseUrl/statistics/summary').replace(
        queryParameters: month != null ? {'month': month} : null,
      );
  static Uri statisticsCategories({String? month}) =>
      Uri.parse('$baseUrl/statistics/categories').replace(
        queryParameters: month != null ? {'month': month} : null,
      );
}
 