import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/bussiness_stats/business_stats_model.dart'
    show BusinessStats;
import '../../../domain/entities/monthly_stats/monthly_stats_model.dart'
    show MonthlyStats;

final businessStatsProvider = FutureProvider<BusinessStats>((ref) async {
  // Simula datos reales (reemplaza con Firestore luego)

  await Future.delayed(const Duration(seconds: 1));
  return BusinessStats(
    ingresos: 5000,
    gastos: 2000,
    ganancia: 3000,
    historico: [
      MonthlyStats(month: 'Ene', ingresos: 3000, gastos: 1500),
      MonthlyStats(month: 'Feb', ingresos: 7500, gastos: 1800),
      MonthlyStats(month: 'Mar', ingresos: 5000, gastos: 2000),
    ],
  );
});
