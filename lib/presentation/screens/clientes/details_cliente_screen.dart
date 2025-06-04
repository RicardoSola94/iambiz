import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/domain/entities/clientes/clientes_model.dart';

import '../../providers/cliente_providers/clientes_providers.dart';
import '../widgets/custom_button.dart';

class ClienteDetailsScreen extends ConsumerWidget {
  final String id;

  const ClienteDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cliente = ref
        .watch(clientesProvider)
        .maybeWhen(
          data: (clientes) {
            try {
              return clientes.firstWhere((c) => c.id == id);
            } catch (_) {
              return null;
            }
          },
          orElse: () => null,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Detalles',
          style: IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 26),
        ),
      ),
      body:
          cliente == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              _InfoItem(title: "Nombre", value: cliente.nombre),
                              const SizedBox(height: 20),
                              _InfoItem(
                                title: "Teléfono",
                                value: cliente.telefono,
                              ),
                              const SizedBox(height: 20),
                              _InfoItem(title: "Correo", value: cliente.correo),
                              const SizedBox(height: 40),

                              // Botón de Editar
                              CustomButton(
                                text: 'Editar',
                                icon: FontAwesomeIcons.penToSquare,
                                isLarge: true,
                                onPressed: () {
                                  context.push('/edit-cliente', extra: cliente);
                                  ref.invalidate(clientesProvider);
                                },
                              ),

                              const SizedBox(height: 40),

                              Text(
                                'Historial de cotizaciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Aquí se mostrará el historial de cotizaciones...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              Text(
                                'Notas del cliente',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Aquí se podrán escribir o ver notas importantes...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
