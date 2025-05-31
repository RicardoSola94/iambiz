import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/colors.dart';
import 'package:iambiz/domain/entities/inventory/inventory_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../providers/inventory/inventory_providers.dart';
import '../screen.dart';
import '../widgets/custom_dropdown.dart';

class AddInventoryScreen extends ConsumerStatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  AddInventoryScreenState createState() => AddInventoryScreenState();
}

class AddInventoryScreenState extends ConsumerState<AddInventoryScreen> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final unitController = TextEditingController();
  final quantityController = TextEditingController();
  final minQuantityController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final salePriceController = TextEditingController();

  String? nameError;
  String? quantityError;
  String? selectedUnit;
  String? unitError;
  String? selectedCategoria;
  String? categoriaError;

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    unitController.dispose();
    quantityController.dispose();
    minQuantityController.dispose();
    purchasePriceController.dispose();
    salePriceController.dispose();
    super.dispose();
  }

  String? validateRequired(String value) {
    if (value.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  String? validateNumber(String value) {
    if (value.trim().isEmpty) return 'Campo obligatorio';
    if (double.tryParse(value) == null) return 'Número inválido';
    return null;
  }

  String? validateCategoria(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecciona una categoría';
    }
    return null;
  }

  String? validateUnit(String? unit) {
    if (unit == null || unit.isEmpty) {
      return 'Selecciona una unidad';
    }
    return null;
  }

  void _save() async {
    final name = nameController.text;
    final category = selectedCategoria ?? '';
    final unit = selectedUnit ?? '';
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final minQuantity = int.tryParse(minQuantityController.text) ?? 0;
    final purchasePrice = double.tryParse(purchasePriceController.text) ?? 0;

    final salePrice =
        salePriceController.text.trim().isEmpty
            ? null
            : double.tryParse(salePriceController.text);

    setState(() {
      nameError = validateRequired(name);
      quantityError = validateNumber(quantityController.text);
      unitError = validateUnit(selectedUnit);
      categoriaError = validateCategoria(selectedCategoria);
    });

    if (nameError != null ||
        quantityError != null ||
        unitError != null ||
        categoriaError != null) {
      return;
    }

    try {
      await ref
          .read(inventoryProvider.notifier)
          .addItem(
            InventoryModel(
              id: '',
              name: name,
              category: category,
              unit: unit,
              quantity: quantity,
              minQuantity: minQuantity,
              purchasePrice: purchasePrice,
              salePrice: salePrice,
              createdAt: DateTime.now(),
            ),
          );

      if (!mounted) return;
      context.go('/inventory');
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);

    const List<String> categoriasInventario = [
      'Herramientas',
      'Materiales',
      'Productos terminados',
      'Consumibles',
      'Equipo de seguridad',
      'Limpieza',
      'Accesorios',
      'Repuestos',
      'Empaque y embalaje',
      'Tecnología',
      'Otros',
    ];

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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
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
                                      "Inventario",
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
                                      onTap: () => context.go('/inventory'),
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
                          const SizedBox(height: 140),
                          CustomTextfield(
                            label: "Nombre del producto",
                            hint: "Nombre",
                            controller: nameController,
                            errorText: nameError,
                          ),
                          const SizedBox(height: 20),
                          CustomDropdownField(
                            label: "Categoría",
                            hint: "Ej: Herramienta, Accesorio, etc",
                            value: selectedCategoria,
                            items: categoriasInventario,
                            onChanged:
                                (val) =>
                                    setState(() => selectedCategoria = val),
                            errorText: categoriaError,
                          ),

                          const SizedBox(height: 20),
                          CustomDropdownField(
                            label: "Unidad de medida",
                            hint: "Ej: Kg",
                            value: selectedUnit,
                            items: [
                              'Unidad',
                              'Kg',
                              'Litro',
                              'Metro',
                              'Caja',
                              'Pieza',
                            ],
                            onChanged:
                                (val) => setState(() => selectedUnit = val),
                            errorText: unitError,
                          ),

                          const SizedBox(height: 20),
                          CustomTextfield(
                            label: "Cantidad",
                            hint: "Ej: 10",
                            keyboardType: TextInputType.number,
                            controller: quantityController,
                            //keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomTextfield(
                                  //hint: "Cantidad mínima",
                                  label: "Cantidad mínima",
                                  hint: "Ej: 3",
                                  keyboardType: TextInputType.number,
                                  controller: minQuantityController,
                                  //keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 8),
                              Tooltip(
                                message:
                                    "Es la cantidad mínima de este ítem en tu inventario antes de que se considere bajo.",
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: TextStyle(color: Colors.white),
                                child: Icon(
                                  CupertinoIcons.info_circle,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          CustomTextfield(
                            label: "Precio de compra",
                            hint: "Ej: 20.00",
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            controller: purchasePriceController,
                            //  keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          CustomTextfield(
                            label: "Precio de venta (opcional)",
                            hint: "Ej: 20.00",
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            controller: salePriceController,
                          ),

                          const SizedBox(height: 50),
                          CustomButton(
                            text: 'Guardar',
                            icon: FontAwesomeIcons.floppyDisk,
                            isLarge: true,
                            onPressed: _save,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (inventoryAsync.isLoading)
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
