enum AppRoutes {
  home('/', 'home'),
  addTransaction('/add-transaction', 'addTransaction'),
  stats('/stats', 'stats'),
  budgetGoals('/budget-goals', 'budgetGoals'),
  newGoal('/new-goal', 'newGoal');

  final String path;
  final String name;
  const AppRoutes(this.path, this.name);
}