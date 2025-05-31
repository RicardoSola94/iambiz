import '../monthly_stats/monthly_stats_model.dart';

class BusinessStats {
  final double ingresos;
  final double gastos;
  final double ganancia;
  final List<MonthlyStats> historico;

  BusinessStats({
    required this.ingresos,
    required this.gastos,
    required this.ganancia,
    required this.historico,
  });
}
