import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/config/config.dart';
import 'package:iambiz/presentation/providers/business_stats_providers/business_stats_providers.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../providers/quotations/quotations_providers.dart';
import 'home_loading_shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(businessStatsProvider);
    final quotationsAsync = ref.watch(quotationProvider);

    final trabajosHoy = [
      TrabajoProgramado(
        cliente: 'Luis Pérez',
        servicio: 'Reparación eléctrica',
        hora: DateTime.now().copyWith(hour: 9, minute: 0),
      ),
      TrabajoProgramado(
        cliente: 'Marta Jiménez',
        servicio: 'Instalación de aire',
        hora: DateTime.now().copyWith(hour: 11, minute: 30),
      ),
      TrabajoProgramado(
        cliente: 'Carlos Ruiz',
        servicio: 'Revisión de plomería',
        hora: DateTime.now().copyWith(hour: 15, minute: 0),
      ),
    ];

    Color _getStatusColor(String status) {
      switch (status) {
        case 'borrador':
          return Colors.orange;
        case 'enviada':
          return Colors.blue;
        case 'aceptada':
          return Colors.green;
        case 'cancelada':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String _getStatusLabel(String status) {
      switch (status) {
        case 'borrador':
          return 'No Enviado';
        case 'enviada':
          return 'Enviada';
        case 'aceptada':
          return 'Aceptada';
        case 'cancelada':
          return 'Cancelada';
        default:
          return 'Desconocido';
      }
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 89),
        child: FloatingActionButton.extended(
          label: const Text('Cotizar', style: TextStyle(color: Colors.white)),
          icon: const Icon(CupertinoIcons.doc_text, color: Colors.white),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            context.go('/quote-cliente');
          },
        ),
      ),
      body: statsAsync.when(
        loading: () => HomeLoadingShimmer(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data:
            (stats) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            //context.go('/quote-cliente');
                          },
                          icon: Icon(CupertinoIcons.settings, size: 30),
                        ),
                        Center(
                          child: Text('IAmBiz', style: IAmBizTheme.h1TextStyle),
                        ),
                        IconButton(
                          onPressed: () {
                            context.go('/calendar-task');
                          },
                          icon: Icon(CupertinoIcons.calendar_today, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('¡Bienvenido!', style: IAmBizTheme.h1TextStyle),
                    const SizedBox(height: 8),
                    Text(
                      'Aquí tienes el resumen de tu negocio este mes:',
                      style: IAmBizTheme.subtitlesTextStyle,
                    ),
                    const SizedBox(height: 24),
                    buildResumenFinanciero(
                      stats.ingresos,
                      stats.gastos,
                      stats.ganancia,
                    ),

                    const SizedBox(height: 24),
                    quotationsAsync.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),

                      error: (e, _) => Text('Error cargando cotizaciones: $e'),
                      data: (quotations) {
                        final latestFive = quotations.reversed.take(3).toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Últimas cotizaciones',
                                  style: IAmBizTheme.h3TextStyle,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      context.go('/quotations');
                                    },
                                    child: Text(
                                      'Ver más',
                                      style: IAmBizTheme.subtitlesTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            latestFive.isEmpty
                                ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.doc_text,
                                          size: 48,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'No hay cotizaciones recientes',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      latestFive.map((cotizacion) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    AppColors.lightprimaryColor,
                                                blurRadius: 2,
                                                offset: const Offset(
                                                  0,
                                                  3,
                                                ), // Solo hacia abajo
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cotizacion.name,
                                                      style:
                                                          IAmBizTheme
                                                              .bodyTextTheme,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Cliente: ${cotizacion.client.nombre} | Total: \$${cotizacion.total.toStringAsFixed(2)}',
                                                      style:
                                                          IAmBizTheme
                                                              .subtitlesTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${cotizacion.createdAt.day}/${cotizacion.createdAt.month}/${cotizacion.createdAt.year}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: _getStatusColor(
                                                        cotizacion.status,
                                                      ).withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      _getStatusLabel(
                                                        cotizacion.status,
                                                      ),
                                                      style: TextStyle(
                                                        color: _getStatusColor(
                                                          cotizacion.status,
                                                        ),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Para hoy:', style: IAmBizTheme.h3TextStyle),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      child: buildTimeline(trabajosHoy),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

Widget buildResumenFinanciero(double ingresos, double gastos, double ganancia) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.primaryColor,
      // gradient: LinearGradient(
      //   colors: [AppColors.primaryColor, Colors.white],
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      // ),
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(16),
    //margin: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // INGRESOS
        Text(
          'Ingresos',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${ingresos.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // LÍNEA DIVISORIA
        Divider(color: Colors.white.withOpacity(0.4), thickness: 1),

        const SizedBox(height: 12),

        // GASTOS y GANANCIA
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Gastos
            Column(
              children: [
                Text(
                  'Gastos',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${gastos.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Ganancia
            Column(
              children: [
                Text(
                  'Ganancia',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${ganancia.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class TrabajoProgramado {
  final String cliente;
  final String servicio;
  final DateTime hora;

  TrabajoProgramado({
    required this.cliente,
    required this.servicio,
    required this.hora,
  });
}

Widget buildTimeline(List<TrabajoProgramado> trabajos) {
  if (trabajos.isEmpty) {
    return Center(
      child: Column(
        children: [
          Icon(CupertinoIcons.wand_stars, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'No hay trabajos programados 🎉',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  return FixedTimeline.tileBuilder(
    theme: TimelineThemeData(
      nodePosition: 0,
      indicatorTheme: const IndicatorThemeData(
        position: 0,
        size: 20,
        color: Colors.blue,
      ),
      connectorTheme: const ConnectorThemeData(
        thickness: 2.5,
        color: Colors.blueAccent,
      ),
    ),
    builder: TimelineTileBuilder.connected(
      connectionDirection: ConnectionDirection.before,
      itemCount: trabajos.length,
      contentsBuilder: (_, index) {
        final trabajo = trabajos[index];
        return Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('hh:mm a').format(trabajo.hora),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(trabajo.cliente, style: const TextStyle(fontSize: 16)),
              Text(trabajo.servicio, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      },
      indicatorBuilder:
          (_, index) => const DotIndicator(color: AppColors.lightprimaryColor),
      connectorBuilder:
          (_, index, __) => SizedBox(
            height: 20.0,
            child: DecoratedLineConnector(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, AppColors.lightprimaryColor],
                ),
              ),
            ),
          ),
    ),
  );
}
