enum AppRoutes {
  home('/'),
  addTransaction('/add-transaction'),
  stats('/stats'),
  budgetGoals('/budget-goals'),
  newGoal('/new-goal');

  const AppRoutes(this.path);
  final String path;
}