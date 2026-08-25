enum AppRoutes {
  home('/', 'home'),
  addTransaction('/add-transaction', 'add-transaction'),
  stats('/stats', 'stats'),
  budgetGoals('/budget-goals', 'budget-goals'),
  newGoal('/new-goal', 'new-goal'),
  notifications('/notifications', 'notifications');

  final String path;
  final String name;
  const AppRoutes(this.path, this.name);
}