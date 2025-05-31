import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/domain/entities/clientes/clientes_model.dart';
import 'package:iambiz/presentation/providers/cliente_providers/clientes_providers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../screen.dart';

class AddClienteQuoteScreen extends ConsumerStatefulWidget {
  const AddClienteQuoteScreen({super.key});

  @override
  AddClienteQuoteScreenState createState() => AddClienteQuoteScreenState();
}

class AddClienteQuoteScreenState extends ConsumerState<AddClienteQuoteScreen> {
  final nombreController = TextEditingController();

  final telefonoController = TextEditingController();

  final correoController = TextEditingController();

  String? nombreError;
  String? telefonoError;
  String? correoError;

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return 'Campo obligatorio';
    if (!email.contains('@')) return 'Email inválido';
    return null;
  }

  String? validateNombre(String nombre) {
    if (nombre.isEmpty) return 'Campo obligatorio';
    //  if (!email.contains('@')) return 'Email inválido';
    return null;
  }

  String? validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return 'El número de teléfono es requerido';
    }

    final numericRegex = RegExp(r'^[0-9]{10,15}$'); // Entre 10 y 15 dígitos

    if (!numericRegex.hasMatch(phone)) {
      return 'Número de teléfono inválido';
    }

    return null;
  }

  void _register() async {
    // Validar campos y mostrar errores si los hay
    final email = correoController.text;
    final name = nombreController.text;
    final phone = telefonoController.text;

    setState(() {
      correoError = validateEmail(email);
      nombreError = validateNombre(name);
      telefonoError = validatePhone(phone);
    });

    // Si hay errores, detener el proceso
    if (correoError != null || nombreError != null || telefonoError != null) {
      return;
    }

    try {
      // Intentar registrar al usuario
      await ref
          .read(clientesProvider.notifier)
          .addCliente(
            ClienteModel(
              id: '', // Firestore lo asigna
              nombre: name,
              telefono: phone,
              correo: email,
              createdAt: DateTime.now(),
              estado: 'activo',
            ),
          );

      if (!mounted) return;
      // Limpiar campos y errores si fue exitoso
      setState(() {
        correoController.clear();
        nombreController.clear();
        telefonoController.clear();

        correoError = null;
        nombreError = null;
        telefonoError = null;
      });

      // Navegar a la pantalla de login
      context.go(
        '/quote-cliente',
      ); // si quieres reemplazar y no mantener historial
    } catch (e) {
      // Mostrar error genérico (por ejemplo, de Firebase)
      final errorMessage = e.toString().replaceAll('Exception: ', '');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: -330,
                      right: -330,
                      child: Container(
                        height: 600,
                        width: 600,
                        decoration: BoxDecoration(
                          color: AppColors.lightprimaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -((1 / 4) * 500),
                      right: -((1 / 4) * 500),
                      child: Container(
                        height: 450,
                        width: 450,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightprimaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          SizedBox(width: double.infinity, height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              // vertical: 12.0,
                            ),
                            child: SizedBox(
                              height: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Texto centrado en pantalla
                                  const Center(
                                    child: Text(
                                      "Cliente",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),

                                  // Flecha atrás en la esquina izquierda
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () => context.go('/quote-cliente'),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.15,
                                              ), // Sombra suave
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          size: 26,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 160),
                          CustomTextfield(
                            label: "Nombre del cliente",
                            hint: "Nombre",
                            controller: nombreController,
                            errorText: nombreError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            label: "Teléfono",
                            hint: "xxx xxxxxxx",
                            keyboardType: TextInputType.phone,
                            controller: telefonoController,
                            errorText: telefonoError,
                          ),
                          SizedBox(height: 20),
                          CustomTextfield(
                            label: "Email",
                            hint: "email@gmail.com",
                            keyboardType: TextInputType.emailAddress,
                            controller: correoController,
                            errorText: correoError,
                          ),

                          SizedBox(height: 50),
                          CustomButton(
                            text: 'Guardar',
                            icon: FontAwesomeIcons.floppyDisk,
                            isLarge: true,
                            onPressed: _register,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (clientesAsync.isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
