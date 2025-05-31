import 'package:iambiz/domain/entities/producto_cotizado.dart/producto_cotizado_model.dart';
import 'package:iambiz/domain/entities/quotation/quotation_model.dart';
import 'package:iambiz/presentation/providers/quotations/quotations_providers.dart'
    show Quotation;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/clientes/clientes_model.dart';
import '../../../domain/entities/quotation/quotation_draft.dart';
import '../../../domain/entities/services/service_model.dart';

part 'quotation_draft_providers.g.dart';

@Riverpod(keepAlive: true)
class QuotationDraft extends _$QuotationDraft {
  @override
  QuotationDraftModel build() => QuotationDraftModel();

  void setClient(ClienteModel client) {
    state = state.copyWith(client: client);
  }

  void addProduct(ProductoCotizado product) {
    final index = state.productos.indexWhere((p) => p.id == product.id);
    List<ProductoCotizado> updatedProducts = List.from(state.productos);

    if (index == -1) {
      // No existe, se añade
      updatedProducts.add(product);
    } else {
      // Ya existe, suma cantidades
      final existing = updatedProducts[index];
      updatedProducts[index] = existing.copyWith(
        quantity: existing.quantity + product.quantity,
      );
    }

    state = state.copyWith(productos: updatedProducts);
  }

  void removeProduct(String id) {
    state = state.copyWith(
      productos: state.productos.where((item) => item.id != id).toList(),
    );
  }

  void addService(ServiceModel service) {
    state = state.copyWith(servicios: [...state.servicios, service]);
  }

  void removeService(String id) {
    state = state.copyWith(
      servicios: state.servicios.where((item) => item.id != id).toList(),
    );
  }

  void clearDraft() {
    state = QuotationDraftModel();
  }

  void addItems(List<ProductoCotizado> items) {
    for (var item in items) {
      addProduct(item);
    }
  }

  void addServices(List<ServiceModel> services) {
    state = state.copyWith(servicios: [...state.servicios, ...services]);
  }

  void clear() {
    state = QuotationDraftModel.empty();
  }

  void setFromQuotation(QuotationModel quotation) {
    final hasData =
        state.client != null ||
        state.productos.isNotEmpty ||
        state.servicios.isNotEmpty;
    if (hasData) return; // Ya hay datos en el draft, no sobreescribir

    state = QuotationDraftModel(
      client: quotation.client,
      productos: List<ProductoCotizado>.from(quotation.productos),
      servicios: List<ServiceModel>.from(quotation.servicios),
    );
  }
}
