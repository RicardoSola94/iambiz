import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iambiz/config/theme/default_theme.dart';
import 'package:iambiz/presentation/screens/widgets/custom_dropdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../config/colors.dart';
import '../../../../domain/entities/inventory/inventory_model.dart';
import '../../../providers/inventory/inventory_providers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddProductoQuoteScreen extends ConsumerStatefulWidget {
  const AddProductoQuoteScreen({super.key});

  @override
  ConsumerState<AddProductoQuoteScreen> createState() =>
      _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState
    extends ConsumerState<AddProductoQuoteScreen> {
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

  void _saveItem() async {
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
      context.go('/quote-products');
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Nuevo Producto',
          style: IAmBizTheme.h1TextStyle.copyWith(), // o el color que necesites
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/quote-products');
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 26),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(30),
        child: CustomButton(
          text: 'Guardar',
          icon: FontAwesomeIcons.floppyDisk,
          isLarge: true,
          onPressed: _saveItem,
        ),
      ),
    );
  }
}
