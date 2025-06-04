import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/presentation/screens/clientes/clientes_loading_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../providers/cliente_providers/clientes_providers.dart';

class ClientesScreen extends ConsumerStatefulWidget {
  const ClientesScreen({super.key});

  @override
  ConsumerState<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends ConsumerState<ClientesScreen> {
  final GlobalKey fabKey = GlobalKey();
  final GlobalKey filterFieldKey = GlobalKey();
  final GlobalKey firstItemKey = GlobalKey();

  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final seen = await hasShownTutorial();
      if (!seen) {
        final clientes = ref.read(filteredClientesProvider);

        initTargets(clientes.isNotEmpty); // 👈 pasar si hay clientes

        showTutorial();
        await markTutorialAsShown();
      }
    });
  }

  void showTutorial() {
    if (!mounted) return;

    if (targets.any((t) => t.keyTarget?.currentContext == null)) {
      Future.delayed(const Duration(milliseconds: 300), showTutorial);
      return;
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SALTAR",
      paddingFocus: 10,
      onFinish: () {
        print("Tutorial terminado");
      },
      onClickTarget: (target) {
        print('Pulsado ${target.identify}');
      },
    ).show(context: context);
  }

  void initTargets(bool hasClientes) {
    targets = [
      TargetFocus(
        identify: "Filter",
        keyTarget: filterFieldKey,
        radius: 10,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              "Usa este filtro para buscar clientes según su estado.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      if (hasClientes) // 👈 solo si hay clientes
        TargetFocus(
          identify: "FirstItem",
          keyTarget: firstItemKey,
          radius: 10,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: const Text(
                "Aquí puedes ver la información del cliente.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      TargetFocus(
        identify: "AddButton",
        keyTarget: fabKey,
        shape: ShapeLightFocus.Circle,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Toca aquí para agregar un nuevo cliente.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    ];
  }

  Future<bool> hasShownTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('clientes_tutorial_shown') ?? false;
  }

  Future<void> markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('clientes_tutorial_shown', true);
  }

  @override
  Widget build(BuildContext context) {
    final clientes = ref.watch(filteredClientesProvider);
    final clientesAsync = ref.watch(clientesProvider);
    final currentFilter = ref.watch(clientesCurrentFilterProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Mis Clientes',
            style:
                IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
          ),
        ),
        body: clientesAsync.when(
          loading: () => ClientesLoadingShimmer(),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (_) {
            return Column(
              children: [
                SizedBox(height: 10),
                SegmentedButton(
                  key: filterFieldKey,
                  segments: const [
                    ButtonSegment(value: FilterType.all, icon: Text('Todos')),
                    ButtonSegment(
                      value: FilterType.completed,
                      icon: Text('Activos'),
                    ),
                    ButtonSegment(
                      value: FilterType.pending,
                      icon: Text('Terminados'),
                    ),
                  ],
                  selected: <FilterType>{currentFilter},
                  onSelectionChanged: (value) {
                    ref
                        .read(clientesCurrentFilterProvider.notifier)
                        .setCurrentFilter(value.first);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child:
                      clientes.isEmpty
                          ? ListView.builder(
                            key:
                                firstItemKey, // <-- Aquí enfoca todo el listado
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Text(
                                    'No hay clientes.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          )
                          : ListView.builder(
                            itemCount: clientes.length,
                            itemBuilder: (context, index) {
                              final cliente = clientes[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/detail-cliente/${cliente.id}');
                                },
                                key: index == 0 ? firstItemKey : null,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightprimaryColor,
                                        blurRadius: 2,
                                        offset: Offset(0, 3),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Fecha y estado (primera fila)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.calendar),
                                              SizedBox(width: 5),
                                              Text(
                                                // Asegúrate de que tienes un campo `createdAt` tipo DateTime
                                                DateFormat(
                                                  'd MMM yyyy',
                                                ).format(cliente.createdAt),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                            value: cliente.estado == 'activo',
                                            onChanged: (bool value) {
                                              // Aquí llamas a la función para actualizar el estado del cliente
                                              // ref
                                              //     .read(clientesProvider.notifier)
                                              //     .updateCliente(
                                              //       cliente.copyWith(
                                              //         estado:
                                              //             value ? 'activo' : 'inactivo',
                                              //       ),
                                              //     );
                                            },
                                            activeColor: AppColors.primaryColor,
                                            inactiveThumbColor: Colors.grey,
                                            inactiveTrackColor:
                                                Colors.grey.shade300,
                                          ),
                                        ],
                                      ),
                                      //const SizedBox(height: 5),
                                      // Nombre
                                      Text(
                                        cliente.nombre,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      //const SizedBox(height: 4),

                                      // Correo
                                      Text(
                                        cliente.correo,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),

                                      //const SizedBox(height: 4),
                                      // Teléfono + Icono
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Teléfono:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                cliente.telefono,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              FontAwesomeIcons.phone,
                                              size: 18,

                                              //  color: Colors.teal, // Color del ícono
                                            ),
                                            onPressed: () {
                                              // launchUrl(Uri.parse('tel:${cliente.telefono}'));
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: FloatingActionButton.extended(
            key: fabKey,
            backgroundColor: AppColors.primaryColor,
            heroTag: 'fab_nuevo_cliente',
            label: const Text(
              'Nuevo Cliente',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(CupertinoIcons.add, color: Colors.white),
            onPressed: () {
              context.go('/add-cliente');
            },
          ),
        ),
      ),
    );
  }
}
