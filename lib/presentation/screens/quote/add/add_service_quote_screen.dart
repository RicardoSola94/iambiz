import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/domain/entities/services/service_model.dart';
import 'package:iambiz/presentation/providers/services_providers/service_providers.dart';

import '../../../../config/colors.dart';
import '../../../../config/config.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddServiceQuoteScreen extends ConsumerStatefulWidget {
  const AddServiceQuoteScreen({super.key});

  @override
  ConsumerState<AddServiceQuoteScreen> createState() =>
      _AddServiceQuoteScreenState();
}

class _AddServiceQuoteScreenState extends ConsumerState<AddServiceQuoteScreen> {
  final nameController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();

  String? nameError;
  String? descripcionError;
  String? precioError;

  @override
  void dispose() {
    nameController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  String? validateRequired(String value) {
    if (value.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  void _saveItem() async {
    final name = nameController.text;
    final descripcion = descripcionController.text;
    final precio = double.tryParse(precioController.text) ?? 0;

    setState(() {
      nameError = validateRequired(name);
      descripcionError = validateRequired(descripcionController.text);
    });

    if (nameError != null || descripcionError != null) {
      return;
    }

    try {
      await ref
          .read(servicesProvider.notifier)
          .addService(
            ServiceModel(
              id: '',
              name: name,
              description: descripcion,
              price: precio,
              createdAt: DateTime.now(),
            ),
          );

      if (!mounted) return;
      context.go('/quote-service');
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Nuevo Servicio',
          style: IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/quote-service');
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 26),
        ),
      ),
      body:
      // Contenido
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomTextfield(
              label: "Nombre del servicio",
              hint: "Nombre",
              controller: nameController,
              // errorText: nameError,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              label: "Descripción del servicio",
              hint: "Descripción",
              controller: descripcionController,
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              label: "Precio",
              hint: "Ej: 20.00",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              controller: precioController,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(30),
        child: CustomButton(
          text: "Guardar",
          icon: FontAwesomeIcons.floppyDisk,
          isLarge: true,
          onPressed: _saveItem,
        ),
      ),
    );
  }
}
