
class ApiConfig {
  static const String baseUrl = 'https://mortally-egotistic-presume.ngrok-free.dev/api';

  // Transactions
  static String transactions() => '/transactions';
  static String transaction(String id) => '/transactions/$id';

  // Categories
  static String categories() => '/categories';
  static String category(int id) => '/categories/$id';

  // Notifications
  static String notifications() => '/notifications';
  static String notificationsUnread() => '/notifications/unread';
  static String notificationRead(int id) => '/notifications/$id/read';
  static String notificationsReadAll() => '/notifications/read-all';

  // Budget targets
  static String budgetTargets() => '/budget-targets';
  static String budgetTarget(int id) => '/budget-targets/$id';

  // Statistics — month теперь передаётся через queryParameters
  static String statisticsSummary() => '/statistics/summary';
  static String statisticsCategories() => '/statistics/categories';
}