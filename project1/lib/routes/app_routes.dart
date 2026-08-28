enum AppRoutes {
  home('/', 'home'),
  transaction('/transaction', 'transaction'),
  statistics('/statistics', 'statistics'),
  goals('/goals', 'goals'),
  newGoal('/newGoal', 'newGoal'),
  notification('/notification', 'notification');

  const AppRoutes(this.path, this.name);

  final String path;
  final String name;
}