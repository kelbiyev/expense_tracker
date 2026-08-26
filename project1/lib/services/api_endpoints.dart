class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'https://mortally-egotistic-presume.ngrok-free.dev/api';

  // ---- Transactions ----
  static const String transactions = '$baseUrl/transactions';
  static String transactionById(String id) => '$baseUrl/transactions/$id';

  // ---- Categories ----
  static const String categories = '$baseUrl/categories';
  static String categoryById(int id) => '$baseUrl/categories/$id';

  // ---- Budget targets ----
  static const String budgetTargets = '$baseUrl/budget-targets';
  static String budgetTargetById(int id) => '$baseUrl/budget-targets/$id';

  // ---- Statistics — month передаётся через queryParameters у dio,
  // не собирается в путь вручную.
  static const String statisticsSummary = '$baseUrl/statistics/summary';
  static const String statisticsCategories = '$baseUrl/statistics/categories';

  // ---- Notifications ----
  static const String notifications = '$baseUrl/notifications';
  static const String notificationsUnread = '$baseUrl/notifications/unread';
  static const String notificationsReadAll = '$baseUrl/notifications/read-all';
  static String notificationRead(int id) => '$baseUrl/notifications/$id/read';
}