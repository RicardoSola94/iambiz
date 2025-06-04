import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/domain/entities/clientes/clientes_model.dart';
import 'package:iambiz/presentation/providers/cliente_providers/clientes_providers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../screen.dart';

class AddClienteScreen extends ConsumerStatefulWidget {
  const AddClienteScreen({super.key});

  @override
  AddClienteScreenState createState() => AddClienteScreenState();
}

class AddClienteScreenState extends ConsumerState<AddClienteScreen> {
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
      context.go('/clientes'); // si quieres reemplazar y no mantener historial
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cliente',
          style: IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/clientes');
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 26),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
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
                    ],
                  ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: CustomButton(
          text: 'Guardar',
          icon: FontAwesomeIcons.floppyDisk,
          isLarge: true,
          onPressed: _register,
        ),
      ),
    );
  }
}
